Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC0EDBACB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 02:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388305AbfJRA0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 20:26:06 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37179 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbfJRA0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 20:26:06 -0400
Received: by mail-lf1-f67.google.com with SMTP id g21so2168754lfh.4
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 17:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aZ+YZXy46MlAIaJTPVbcRMJjSIL+LBp5qj36izVSGc4=;
        b=iun/tz4Rj0q2mwN7/Cq9hTRWk4gR5Uwb8fBwmzkIdU6cdEEVpq7jHqUCSAQx6qdhS+
         /SzyUNp2HI3GtHSEY+OvHuRrqoXF2Y5Bh93WiqF0fGfak7llRmwj3R0UzARIGr1UbQ6Z
         5YsMM1OUlUAqcfWFM7p0PYTn3761MVgU9cJ98zGaJSXn0lnF/1iMpvQ/mOTfBPew/OlO
         S/ZYeBNd7VgLfwgYY/n+JfD4DkYPsrzwNGF5QPbZjCJvKj76av9ZGdA3mUFizrn95f3v
         jKhbkqgdESBgUf3CkQCwy8SfZiS6pA8Ch4CxXrrcbbUVkp3xpNvo1YRQpS71c7530xoB
         A5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aZ+YZXy46MlAIaJTPVbcRMJjSIL+LBp5qj36izVSGc4=;
        b=cQOeOm8LY3Q/t2mu3YEurKS9E1aW27LwX7XrdIw7ITeP172HD2O70MaMdSZXgGSG5G
         pcxuQEm1CO5J/SrKnZjg9WK16k7bY96UtX1qtFx+Cg6Mc8ns2StsSIcfsnxl4kQgqjHT
         03EIU0eTfI+NRb8Ggbm+KJVa1LfkIDILhFyqxFW71fYYvrJMcII5B/xEwcOUFtz7f7BU
         Y2TJ+X4ULtTy8qfOYMsC6y7GHLo+gRn++k/8wg81JOAeaZKwRDc8QlvghQChf60guZMa
         vLeQ9oLgSi+hJG8tpqQMR7AEOf+qYhhPN0fwu8XVSEoPMBgCDXWB7JwUb8yP0bOn2745
         vnFw==
X-Gm-Message-State: APjAAAX7NyDg15tW4dCCZ2MhhNH37bzNXe69y/GIz4Jae47U/youMPpm
        XDmnzcM9ORxrnQs4s0YUFVmy9A==
X-Google-Smtp-Source: APXvYqyAhxPxNBQMo0iPNjgtKV9wpdcSLmr+vD+5Z8GblDf0YRvC5Kyn4ROqHAiC6iRpNYcTHIQIWw==
X-Received: by 2002:ac2:4888:: with SMTP id x8mr3985196lfc.90.1571358364358;
        Thu, 17 Oct 2019 17:26:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 81sm1805862lje.70.2019.10.17.17.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 17:26:03 -0700 (PDT)
Date:   Thu, 17 Oct 2019 17:25:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
Message-ID: <20191017172555.3e550d33@cakuba.netronome.com>
In-Reply-To: <20191017164825.22d223d1@cakuba.netronome.com>
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
        <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
        <20190918142549.69bfa285@cakuba.netronome.com>
        <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
        <20190918144528.57a5cb50@cakuba.netronome.com>
        <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
        <20190923172811.1f620803@cakuba.netronome.com>
        <CAOrEds=zEh5R_4G1UuT-Ee3LT-ZiTV=1JNWb_4a=5Mb4coFEVg@mail.gmail.com>
        <20190927173753.418634ef@cakuba.netronome.com>
        <20191009165739.GA1848@kvmhost.ch.hwng.net>
        <20191017164825.22d223d1@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 16:48:25 -0700, Jakub Kicinski wrote:
> > The only patch that we have been able to make consistently work
> > without crashing and also without compromising performance, is the
> > previously submitted one where later thread bails out of
> > tls_tx_records. And as mentioned, it can perhaps be made more
> > efficient by rescheduling delayed work in the case where work handler
> > thread turns out to be the later thread that has to bail.  
> 
> Let me try to find a way to repro this reliably without any funky
> accelerators. The sleep in do_tcp_sendpages() should affect all cases.
> I should have some time today and tomorrow to look into this, bear with
> me..

Could you please try this?

---->8-----

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c2b5e0d2ba1a..ab7b0af162a7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1204,12 +1204,10 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 		goto alloc_payload;
 	}
 
-	if (num_async) {
-		/* Transmit if any encryptions have completed */
-		if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
-			cancel_delayed_work(&ctx->tx_work.work);
-			tls_tx_records(sk, flags);
-		}
+	/* Transmit if any encryptions have completed */
+	if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		cancel_delayed_work(&ctx->tx_work.work);
+		tls_tx_records(sk, flags);
 	}
 sendpage_end:
 	ret = sk_stream_error(sk, flags, ret);
@@ -2171,7 +2169,8 @@ static void tx_work_handler(struct work_struct *work)
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
 	lock_sock(sk);
-	tls_tx_records(sk, -1);
+	if (!sk->sk_write_pending)
+		tls_tx_records(sk, -1);
 	release_sock(sk);
 }
 
