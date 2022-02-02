Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0355F4A748F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 16:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345134AbiBBPY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 10:24:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230120AbiBBPY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 10:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643815466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=wbfCqbIp07biNHmVcfksEUeSGRpB450MoXKgsGlsSvU=;
        b=HMemB6W1MJl6f/EhBa1diVX0153MfAtp76qCqgrONHmB7YxuDWviql5atT5wf7tQUbNAug
        hL/PwPRm59oTyVT9nYyrauHIOA23qzamnckV8SheO1F/2CziX7PO3O9VBfEGp/f2dDpQlF
        rvh3xt0uOb9uKpiNi4kfHekyXZ9R5lc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-38aNWrLIOLKdHHtnS19v1w-1; Wed, 02 Feb 2022 10:24:25 -0500
X-MC-Unique: 38aNWrLIOLKdHHtnS19v1w-1
Received: by mail-wr1-f69.google.com with SMTP id r2-20020adfa142000000b001e176ac1ec3so2766277wrr.3
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 07:24:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=wbfCqbIp07biNHmVcfksEUeSGRpB450MoXKgsGlsSvU=;
        b=CoF+kUpGywppRfTLqvUp1jPQM24VwjNdYQzKD5JuctxPKktMkBhWUCIlpGYPAFi8WB
         hq5Nw6laOx1d7J74flPkZrDcSomwheE18f0MgzJmJ1e/dqu2FEdCovgxI+tFeqlwVbHs
         8jzJQ7eGdyWF4QhItExRiJJkWCqo7adA9Tl8vozPi9EuKk+aHYu/AFD27Y94k0nLaVI0
         SXWxC5JhDvJIpJ1d5QPIWZkdfVHO0jbijUCUYSEOVaeMGW+gfd5yOsMoyokFfq2zhabc
         pZVtsOGzsY2Xo5flBzTAWNszwzmviA4zbjXn8xAqeOHGEY2H2jrg3FNJV0depFqOT8v4
         hKeg==
X-Gm-Message-State: AOAM531utHCD1iHJB3MWmq5jq0/fJpezA9rewN3Dk6dy9IhK2vrNTZvS
        f+BnqYUinWg3EUtSiH+UCFki/hott3W+8UlTeuaw9RQS81nrzZy3REjSqe80buJn5EV9Skn6wrW
        MgID/ify8XRJvoxLa
X-Received: by 2002:adf:d1e9:: with SMTP id g9mr25495218wrd.166.1643815464417;
        Wed, 02 Feb 2022 07:24:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlOhXtDJ+HPBsWYCYPkfTLAvav6APznjRzlOdHckDMQxh4xTH4iZD4qtIRH5SWVifZEpvEqg==
X-Received: by 2002:adf:d1e9:: with SMTP id g9mr25495200wrd.166.1643815464205;
        Wed, 02 Feb 2022 07:24:24 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id ay3sm4988031wmb.44.2022.02.02.07.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 07:24:23 -0800 (PST)
Date:   Wed, 2 Feb 2022 16:24:21 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] selftests: rtnetlink: Use more sensible tos values
Message-ID: <d61119e68d01ba7ef3ba50c1345a5123a11de123.1643815297.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using tos 0x1 with 'ip route get <IPv4 address> ...' doesn't test much
of the tos option handling: 0x1 just sets an ECN bit, which is cleared
by inet_rtm_getroute() before doing the fib lookup. Let's use 0x10
instead, which is actually taken into account in the route lookup (and
is less surprising for the reader).

For consistency, use 0x10 for the IPv6 route lookup too (IPv6 currently
doesn't clear ECN bits, but might do so in the future).

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
No Fixes tag, since this is for net-next and the original test wasn't
actually broken in the first place.

 tools/testing/selftests/net/rtnetlink.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index c9ce3dfa42ee..0900c5438fbb 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -216,9 +216,9 @@ kci_test_route_get()
 	check_err $?
 	ip route get fe80::1 dev "$devdummy" > /dev/null
 	check_err $?
-	ip route get 127.0.0.1 from 127.0.0.1 oif lo tos 0x1 mark 0x1 > /dev/null
+	ip route get 127.0.0.1 from 127.0.0.1 oif lo tos 0x10 mark 0x1 > /dev/null
 	check_err $?
-	ip route get ::1 from ::1 iif lo oif lo tos 0x1 mark 0x1 > /dev/null
+	ip route get ::1 from ::1 iif lo oif lo tos 0x10 mark 0x1 > /dev/null
 	check_err $?
 	ip addr add dev "$devdummy" 10.23.7.11/24
 	check_err $?
-- 
2.21.3

