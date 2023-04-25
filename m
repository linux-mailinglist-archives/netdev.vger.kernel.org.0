Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E976EE4C0
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjDYP2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbjDYP2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:28:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CC414474
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682436417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fNJCEabiLtGfgYw9tXVC70Fuu6erYNndNresacEPBw=;
        b=PFs1UBQjSjfRWOSQdB6FV5UXPRAShdF/j/iIFAlCW10UXmA5xFsfRYAbetGbIa9P2udd3z
        mRiQUebixfpvWApPPTnFqeVUXSJSlGnBDv0L5ZQcqxuMSzyT5mN6IbQB4t7BsqzvvQx96b
        G3PVIpY6mJKcB4AFI03EiR87ISdkHmg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-8XZCnvROMa6qlNMUwNktHg-1; Tue, 25 Apr 2023 11:26:55 -0400
X-MC-Unique: 8XZCnvROMa6qlNMUwNktHg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-50470d68f1eso5541682a12.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:26:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682436414; x=1685028414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fNJCEabiLtGfgYw9tXVC70Fuu6erYNndNresacEPBw=;
        b=dFSyQPpDtHYHJ1E+fMKTiEcfyYbl3FLjyC8ZgJF8XEShm4MDe+h1xBiZcm6837H/N+
         X4ZiXI7fTakOsFsrYincrijBBVjbHYETyuUYwGaYLd5qFb6gryaLxxMaNB3hKR3GnNur
         QBawWe60chiYRRGiT76Cr9n6tx/599+Mv/2G6cuqzXPoqKoUOKfdBei24JOQZKOvVicX
         2fft7t0EhBEmJhMrnfehasQPlZKqt9+JJ58M6hDa7IPfkVYyuHAsHMISGrWYlr9TckuF
         nBAm+4Z223ZL72bxwn1qVyeVXM9BEnfsmU+kbG1/LQGcZS1tJVqmn3lMGyo07QNIKDMj
         3JDg==
X-Gm-Message-State: AAQBX9cxK5VvAC16ZP1Xucx+drkqfzXpE0M/5xRs3sRW043YSGaFkfgC
        Tv1UVV4hyPAn4JtNtNqJ7buLTxdTSZHFx4d6mL9HW/ZKeDENvEcyXOHUQOF2tqNbLwr23zLKGYB
        FjCT6/72mI4vr8GW+WynlTV/ld+lgI07VsL48sHqzGpQ=
X-Received: by 2002:a05:6402:10cb:b0:506:9f0f:dcaf with SMTP id p11-20020a05640210cb00b005069f0fdcafmr13935919edu.37.1682436414208;
        Tue, 25 Apr 2023 08:26:54 -0700 (PDT)
X-Google-Smtp-Source: AKy350YvKH6fTZE4WMgQyG5NYzx5UK0EANnycRA8tgUlK0TN/48kCUPIhh0Lfy4giK4QSpupOa1Cnb4D8ScVXomi8V0=
X-Received: by 2002:a05:6402:10cb:b0:506:9f0f:dcaf with SMTP id
 p11-20020a05640210cb00b005069f0fdcafmr13935902edu.37.1682436413929; Tue, 25
 Apr 2023 08:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230417093412.12161-1-wojciech.drewek@intel.com> <20230417093412.12161-3-wojciech.drewek@intel.com>
In-Reply-To: <20230417093412.12161-3-wojciech.drewek@intel.com>
From:   Michal Schmidt <mschmidt@redhat.com>
Date:   Tue, 25 Apr 2023 17:26:42 +0200
Message-ID: <CADEbmW1Tey8dHN4M-xBsgHBOsQZX_aT9k1=FcL=skT_10GYiWg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 02/12] ice: Remove exclusion
 code for RDMA+SRIOV
To:     Wojciech Drewek <wojciech.drewek@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>
Cc:     "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:35=E2=80=AFAM Wojciech Drewek
<wojciech.drewek@intel.com> wrote:
>
> From: Dave Ertman <david.m.ertman@intel.com>
>
> There was a change previously to stop SR-IOV and LAG from existing on the
> same interface.  [...]

Why does the subject mention RDMA? The patch does not change the calls
to ice_{set,clear}_rdma_cap.
Did you mean to call it "ice: Remove exclusion code for LAG+SRIOV" ?

Michal

