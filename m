Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379D86058F3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiJTHrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiJTHrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DBD16F776
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666252019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWdmITFN27a7eSxxtUrIyl/9Iyy7F3ME8iTOdJg2TmM=;
        b=H2Qydv4IwLtLBroBNBeyRrUlB/bxeNfuHcO2utlzkpFbsD/ATg1QRxbY4Ri74MyG5ERY0n
        Ij2JFSPW7K4umifhaGRhlYjdZoyzyF8OmnI9d2PjRePPhVd0NoFlmSY8uOLkWJxlMKi0L1
        dnzu9G05FYoaFm5+U5IJnJj9QTJnf1g=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-152-aMTgEobeOfGmIqC2H-3ozA-1; Thu, 20 Oct 2022 03:46:58 -0400
X-MC-Unique: aMTgEobeOfGmIqC2H-3ozA-1
Received: by mail-pj1-f69.google.com with SMTP id w13-20020a17090a1b8d00b0021177fe317cso910346pjc.7
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWdmITFN27a7eSxxtUrIyl/9Iyy7F3ME8iTOdJg2TmM=;
        b=1rm6vA6REM3GYd2POgw2pvy0wkrKWLGFCwMjy6tiMLKnTTkPNCEDK6QwmxMCXamrr4
         z7oHUAlXO7/Aie66bKDNJMOEUeS593LyD9YbA0q6sp1RduZai9gboD7wuW+GBo3o2y46
         CKpP3aZckMrQeOnyxV+VYcJBHtwSNA4Q1LmO+hJqWm1mzkL3+1a7Lx2muw3ndvnVA1gG
         DHCrbVQskd4TSS6/r4W1m+SIr4eHQVdxKiUM8Cl/q+uyn7pCcD+dMYxi10c/9ydhbZ0G
         sDedRBFXIP6ZN2qjUIJmtft1yfn/f19QXdCnWGblnOnvu+j0ibeD5Avwa6uUZdxsUgjo
         9srA==
X-Gm-Message-State: ACrzQf1njEVYzlFVLKkgepNce+LApTqu8e0JRhLyfSGNGriXvjm6OLFO
        Aqha7MFqeg0kSFlDBv7/kQdv9HdcAVyzDlYQSbAUBNANQJIr0E+DBuScbmldEIHXH8+Cyw6ci/e
        KgKeWg3AblgraYWuLnmiSO/St5KA5dZ2c
X-Received: by 2002:a63:5422:0:b0:466:41b5:77d4 with SMTP id i34-20020a635422000000b0046641b577d4mr10421297pgb.547.1666252017116;
        Thu, 20 Oct 2022 00:46:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6VSZtRrC9uQuGe50MucTEohLaiyb3ETi9sIHZSNHoyaI8iOXzgEtopUJty7WL3b7gmQ6UIdBLG/VyLNcIuVsA=
X-Received: by 2002:a63:5422:0:b0:466:41b5:77d4 with SMTP id
 i34-20020a635422000000b0046641b577d4mr10421283pgb.547.1666252016828; Thu, 20
 Oct 2022 00:46:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
 <Y0llmkQqmWLDLm52@lunn.ch> <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
 <Y0rNLpmCjHVoO+D1@lunn.ch> <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
 <Y03y/D8WszbjmSwZ@lunn.ch> <20221017194404.0f841a52@kernel.org>
 <CACT4oueGEDLzZLXdd_Pt+tK=CpkMM7uE9ubVL9i6wTO7VkzccA@mail.gmail.com>
 <20221018085906.76f70073@kernel.org> <CACT4oud9B-yCD5jVWRt9c4JXq2_Ap-qMkr9y3xJ5cgTTggYT1w@mail.gmail.com>
 <20221019083913.09437041@kernel.org>
In-Reply-To: <20221019083913.09437041@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 20 Oct 2022 09:46:45 +0200
Message-ID: <CACT4oucNqbFv=xVtOA0HzgjyuCuAMGFxJm14-qgd7tiVT3wSSw@mail.gmail.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, irusskikh@marvell.com,
        dbogdanov@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 5:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> Dunno, locks don't protect operations, they protect state (as the link
> Andrew sent probably explains?),

Yes, you're completely right. I understood that well, and Andrew's
link (which is very good, thanks Andrew) explains it too. I wrongly
said "operations" because in this case the lock/unlock must be done
mainly inside the macsec_ops (operations), and thus my confusion.

I'm about to send my patch. If you still feel that it's not the best
solution, feel free to insist on the refcount or any other approach
you think is better.

Thanks and sorry for the noise
--=20
=C3=8D=C3=B1igo Huguet

