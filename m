Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5044DAD12
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354753AbiCPJAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239096AbiCPJAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:00:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1426B5005C
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647421145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2IQfYLfuAocMPTVuNwxwAuSPOEHSe4nK/cDVLhWner4=;
        b=JRIG7onM41ycHFYOSnZtS92L0psyThIqzv9b5CWsWKpBaJaUsg1x2Ak0KkSB1USnPtE3vj
        UNKuUBdBghlS2wd9sAfRn/MLjU1MbwYEXn+Vqe+BMfV6DSyzA+hGc03QT2DByuFQa8yGBd
        C530ua39NBlnlY+tCU4wgYhI+Ud1PHQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-5z3oZZkFNpWnF9A3umWpDA-1; Wed, 16 Mar 2022 04:59:04 -0400
X-MC-Unique: 5z3oZZkFNpWnF9A3umWpDA-1
Received: by mail-qk1-f199.google.com with SMTP id 12-20020a37090c000000b0067b32f93b90so1065543qkj.16
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2IQfYLfuAocMPTVuNwxwAuSPOEHSe4nK/cDVLhWner4=;
        b=LQQAFeNhDT+2JKKKDWlK1H1zp9JJl5kTIEUp+Y0I5L+imidDfXJp3ltWTRH4Wo72VE
         pLD1LbvFCAWqWK5gy2Q+ysfrAs433MBOiyoRqgy1K08dJqE3t6k+ouMGJohaUH2HYv/u
         ebHE4D86OaZAQ1FkpyX3L8RMfbRek/zw5x7pFifjEFEkxAScEyLhyIK3tEntkUYkbL9c
         KsZFVUcVQsNizage6YR6Q7h8wSfFZGg2m1QmSqW0+TOk+fkBE3CQPFiMrkug64dqKo7P
         jDJNxfTpQ41h1fXrWqDWLxK4cveNm5+71/TtC9kdpQgYc4q6Q5G9hUOZMrl7RvbW7yCK
         dL7g==
X-Gm-Message-State: AOAM5313i3piJd825Jg9LeBk9QrJUrjP8f2EVtaBeZYlwg36Cv+wDE7f
        /5g8Zoue2ye94JcYi5UW003q8ZwwKQLLHT6PWJnwI7oKFuV/VB7D+QNtdIQ6OpELIPuGgVEvJW4
        QNUVOIqpJysRE8Los
X-Received: by 2002:a37:946:0:b0:67d:9d27:3c1 with SMTP id 67-20020a370946000000b0067d9d2703c1mr11964248qkj.476.1647421143373;
        Wed, 16 Mar 2022 01:59:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxE0vzbmy81u38sAbV94J0w29xluplMn3uFAqGcnwP0RR4dmNglMBlgx+GJvoCwd8mKJnazsA==
X-Received: by 2002:a37:946:0:b0:67d:9d27:3c1 with SMTP id 67-20020a370946000000b0067d9d2703c1mr11964239qkj.476.1647421143091;
        Wed, 16 Mar 2022 01:59:03 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.retail.telecomitalia.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id v3-20020a05622a188300b002e1cbca8ea4sm1066677qtc.59.2022.03.16.01.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:59:02 -0700 (PDT)
Date:   Wed, 16 Mar 2022 09:58:54 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] af_vsock: add two new tests for SOCK_SEQPACKET
Message-ID: <20220316085854.estmt5xafafsmp73@sgarzare-redhat>
References: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 07:25:07AM +0000, Krasnov Arseniy Vladimirovich wrote:
>This adds two tests: for receive timeout and reading to invalid
>buffer provided by user. I forgot to put both patches to main
>patchset.
>
>Arseniy Krasnov(2):
>
>af_vsock: SOCK_SEQPACKET receive timeout test
>af_vsock: SOCK_SEQPACKET broken buffer test
>
>tools/testing/vsock/vsock_test.c | 211 +++++++++++++++++++++++++++++++++++++++
>1 file changed, 211 insertions(+)

I think there are only small things to fix, so next series you can 
remove RFC (remember to use net-next).

I added the tests to my suite and everything is running correctly.

I also suggest you to solve these little issues that checkpatch has 
highlighted to have patches ready for submission :-)

Thanks,
Stefano

$ ./scripts/checkpatch.pl --strict -g  master..HEAD
---------------------------------------------------------------------
Commit 2a1bfb93b51d ("af_vsock: SOCK_SEQPACKET receive timeout test")
---------------------------------------------------------------------
CHECK: Unnecessary parentheses around 'errno != EAGAIN'
#70: FILE: tools/testing/vsock/vsock_test.c:434:
+	if ((read(fd, &dummy, sizeof(dummy)) != -1) ||
+	   (errno != EAGAIN)) {

WARNING: From:/Signed-off-by: email name mismatch: 'From: Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>' != 'Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>'

total: 0 errors, 1 warnings, 1 checks, 97 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.

Commit 2a1bfb93b51d ("af_vsock: SOCK_SEQPACKET receive timeout test") has style problems, please review.
-------------------------------------------------------------------
Commit 9176bcabcdd7 ("af_vsock: SOCK_SEQPACKET broken buffer test")
-------------------------------------------------------------------
CHECK: Comparison to NULL could be written "!buf1"
#51: FILE: tools/testing/vsock/vsock_test.c:486:
+	if (buf1 == NULL) {

CHECK: Comparison to NULL could be written "!buf2"
#57: FILE: tools/testing/vsock/vsock_test.c:492:
+	if (buf2 == NULL) {

CHECK: Please don't use multiple blank lines
#152: FILE: tools/testing/vsock/vsock_test.c:587:
+
+

WARNING: From:/Signed-off-by: email name mismatch: 'From: Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>' != 'Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>'

total: 0 errors, 1 warnings, 3 checks, 150 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.

Commit 9176bcabcdd7 ("af_vsock: SOCK_SEQPACKET broken buffer test") has style problems, please review.

NOTE: If any of the errors are false positives, please report
       them to the maintainer, see CHECKPATCH in MAINTAINERS.




