Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28D76E67BA
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbjDRPEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 11:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjDRPEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 11:04:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD80B76E
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681830242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwUK7qUisEu7dIOb1WAcA06+qh2WAKNBpoYewOqKil4=;
        b=eZaQYTWTNk598YnIDM+mMJuzz4h+8ChhTNgUQCD8ikWUzZaA3lWMLDQm3Ri6a5QOd04JVx
        ZgjGwdQmXlekTf41+8//mdw/HOp+OrxXvh1v7YheaZXLDUxtEXza+LHmv/689+RwxRL96y
        Zx3z5DRoS1rMEpCZ8ScSQmwvcJOJnCQ=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-2J21p7SROCS_rkOKqJoceA-1; Tue, 18 Apr 2023 11:04:01 -0400
X-MC-Unique: 2J21p7SROCS_rkOKqJoceA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2a83a0b7be1so8824021fa.1
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 08:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830240; x=1684422240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iwUK7qUisEu7dIOb1WAcA06+qh2WAKNBpoYewOqKil4=;
        b=bbHyviRptBNof98uSd1pAECP1KaS/88jUN8sHkFNzqI75Ms43p2KPQX4All14hmD3m
         2wN1okdg5TAWwAO7ndIjPcOgfp9xkpLmpIhm9VDGtvij5wilYN+g2OmtG6XYHZ8v3x8X
         kCoc7vhklruKT+RCGYk2XY4TVaiGa+bhZdTfMh8pExVtYLgl5Xj3vzpNRRTzS0v7wbW0
         HgVfOkUgR/jxWAtq0U3+/WtIwxNc+VfQ5+27aYhAo30V6McWj4MiRauKwqcOGPY4GMRK
         6GKdCW89vUR5jXIrfsStHhJg95jQDG97e6sK6m9lPybnYpwxAKkEc/6ngXTE1e7tTpwl
         G9lg==
X-Gm-Message-State: AAQBX9cebVTrMDPKZUvfp6OAup1Y2CojAfYFsZuFoOhUjW77oFigi3hy
        VNZlEZX526zn+ntlxYAfmO4Y73d5A12UA3yAbV00r58pK4IjUhTS4Cj/Yo3/7QGF3zo+69FnVdY
        SeJnArFUqDTmXoGJNsb4epiJgXnIQYutC
X-Received: by 2002:a19:c515:0:b0:4ed:af44:1c27 with SMTP id w21-20020a19c515000000b004edaf441c27mr3309633lfe.3.1681830239571;
        Tue, 18 Apr 2023 08:03:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350bNS74G9PITD3o1l5HtfmzCqdNS9l/G/WkdCFaxOfugZatOMFV9bY0Exz55NRlsBfs0y7Ufbs1JdsIV/0zyi9k=
X-Received: by 2002:a19:c515:0:b0:4ed:af44:1c27 with SMTP id
 w21-20020a19c515000000b004edaf441c27mr3309623lfe.3.1681830239069; Tue, 18 Apr
 2023 08:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
 <20230417193031.3ab4ee2a@kernel.org> <CANn89iJ0zy6rr4=O3328heYgiBHNcc9hmAHweTFvAW7iZi8QFw@mail.gmail.com>
 <20230418074333.7d084348@kernel.org>
In-Reply-To: <20230418074333.7d084348@kernel.org>
From:   Davide Caratti <dcaratti@redhat.com>
Date:   Tue, 18 Apr 2023 17:03:47 +0200
Message-ID: <CAKa-r6s2Qn_O+c1_gBT=+5ndHcL92FspSogo22ws3-iCqUSjEw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_fq: fix integer overflow of "credit"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Tue, Apr 18, 2023 at 4:43=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 18 Apr 2023 12:26:13 +0200 Eric Dumazet wrote:
> > > Please set the right policy in fq_policy[] instead.
> >
> > Not sure these policies are available for old kernels (sch_fq was
> > added in linux-3.12) ?

[...]

> Good point, Davide, once the policy based fix hits the trees please
> send this version of the fix to stable@ for 5.4 and older stable trees.

Sure, I will do that. And thanks for the review! :)
--
davide

