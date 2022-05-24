Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B63532522
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiEXITQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiEXITP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:19:15 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2685DA10;
        Tue, 24 May 2022 01:19:13 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id CFF4E1F4384F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1653380351;
        bh=UZRJ19uBktgKUYeBwlR0l4U9RP2hctsCuHcpTxjnTXA=;
        h=Date:From:Subject:Cc:To:From;
        b=CbA4VvBAHV85P+I6KMpuhAjzbA838pt0kGkBQ3b+M9djB/wWFUdQzqdLShR1DeN9J
         bxOn+13LEEpi1W1q+A6IVIElcCAry+j4bNfDJA1P58fa+6i8pE8XpXiuTeWfGlujMp
         NTW/FXoSxMmEk8m1cqzwHC+eNYk4YN3tfaw0NkiHYzWvmlYn8MMx040gCeAapRbt0B
         1W1wmvqtVc8dZoebQDNhLh8lFtPsPcjbXM4V8YTZeb6lFp00Ek3krDjf7IqrrVU/UQ
         p97m3p7aL2tgO9WLsrlowIpDUtZDoUcoyCDjNB+KJIP6w8+MLbbw3VPF5s7zmSDCaM
         Oflm2Gc6iXTXw==
Message-ID: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
Date:   Tue, 24 May 2022 13:18:55 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: [RFC] EADDRINUSE from bind() on application restart after killing
Cc:     usama.anjum@collabora.com,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        LKML <linux-kernel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We have a set of processes which talk with each other through a local
TCP socket. If the process(es) are killed (through SIGKILL) and
restarted at once, the bind() fails with EADDRINUSE error. This error
only appears if application is restarted at once without waiting for 60
seconds or more. It seems that there is some timeout of 60 seconds for
which the previous TCP connection remains alive waiting to get closed
completely. In that duration if we try to connect again, we get the error.

We are able to avoid this error by adding SO_REUSEADDR attribute to the
socket in a hack. But this hack cannot be added to the application
process as we don't own it.

I've looked at the TCP connection states after killing processes in
different ways. The TCP connection ends up in 2 different states with
timeouts:

(1) Timeout associated with FIN_WAIT_1 state which is set through
`tcp_fin_timeout` in procfs (60 seconds by default)

(2) Timeout associated with TIME_WAIT state which cannot be changed. It
seems like this timeout has come from RFC 1337.

The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
also doesn't seem feasible to change the timeout of TIME_WAIT state as
the RFC mentions several hazards. But we are talking about a local TCP
connection where maybe those hazards aren't applicable directly? Is it
possible to change timeout for TIME_WAIT state for only local
connections without any hazards?

We have tested a hack where we replace timeout of TIME_WAIT state from a
value in procfs for local connections. This solves our problem and
application starts to work without any modifications to it.

The question is that what can be the best possible solution here? Any
thoughts will be very helpful.

Regards,

-- 
Muhammad Usama Anjum
