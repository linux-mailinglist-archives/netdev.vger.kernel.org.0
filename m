Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B47576B2A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 03:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiGPBAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 21:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiGPBAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 21:00:13 -0400
X-Greylist: delayed 1018 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 18:00:12 PDT
Received: from mail.codeweavers.com (mail.codeweavers.com [50.203.203.244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B443AE71
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 18:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=codeweavers.com; s=6377696661; h=Subject:To:From:MIME-Version:Date:
        Message-ID:Content-Type:Sender:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ynEeOg/i/NYVmJUhQDvbgS/BhPoy9dUbzInKhWYuU2g=; b=aeuzAAVRTs1UK/ocwT0UlpDrb
        p02btvbI4VY8sEZ993gxB16k4AIeRHtedEjTgC5j/6zAYC5XAHEJ8kOS8D4HHd4EEjGKCbMEgHgOR
        JNqBZwRoqdCq93+46mL1BQ+yRcb+Wz50vp36oIQ/zcuyvdCwDmCiCCrW5KFUrzhjn2lNQ=;
Received: from [10.69.139.42]
        by mail.codeweavers.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <zfigura@codeweavers.com>)
        id 1oCVtp-0003Qr-GK
        for netdev@vger.kernel.org; Fri, 15 Jul 2022 19:43:13 -0500
Content-Type: multipart/mixed; boundary="------------0NTVpZ37c6VtgZo4QOoydsn7"
Message-ID: <84b443dd-9faa-4aa9-5d7e-4836f5cb47e0@codeweavers.com>
Date:   Fri, 15 Jul 2022 19:43:12 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
From:   Zeb Figura <zfigura@codeweavers.com>
To:     netdev@vger.kernel.org
Subject: Odd behaviour with SO_OOBINLINE
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------0NTVpZ37c6VtgZo4QOoydsn7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,

I found what seems like a bug related to SO_OOBINLINE handling with TCP 
sockets. I couldn't easily find any mention of this on the Internet, so 
I'm asking about it here.

The basic problem is best expressed by reading and running the attached 
.c file. As a summary, setting SO_OOBINLINE on a socket after sending 
and receiving OOB data seems to cause that data to be received again. 
This is especially suspicious since making an (unsuccessful) recv() call 
before setting SO_OOBINLINE [commented out with if(0)] will cause said 
recv to return normally.

Is this a bug? Is there anything that should be done about this behaviour?

Thanks,
Zeb
--------------0NTVpZ37c6VtgZo4QOoydsn7
Content-Type: text/x-csrc; charset=UTF-8; name="socktest_oob.c"
Content-Disposition: attachment; filename="socktest_oob.c"
Content-Transfer-Encoding: base64

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8YXJwYS9pbmV0Lmg+CiNpbmNsdWRlIDxl
cnJuby5oPgojaW5jbHVkZSA8bmV0ZGIuaD4KI2luY2x1ZGUgPG5ldGluZXQvaXAuaD4KI2lu
Y2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0cmluZy5o
PgojaW5jbHVkZSA8c3lzL2Vwb2xsLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVk
ZSA8c3lzL3NvY2tldC5oPgojaW5jbHVkZSA8cG9sbC5oPgojaW5jbHVkZSA8dW5pc3RkLmg+
CgppbnQgbWFpbih2b2lkKQp7CiAgICBjb25zdCBzdHJ1Y3Qgc29ja2FkZHJfaW4gY29ubmVj
dF9hZGRyID0gey5zaW5fZmFtaWx5ID0gQUZfSU5FVCwgLnNpbl9hZGRyID0gaHRvbmwoSU5B
RERSX0xPT1BCQUNLKSwgLnNpbl9wb3J0ID0gaHRvbnMoOTM3NCl9OwogICAgaW50IGJ1ZmZl
cl9zaXplID0gMTAyNCAqIDEwMjQ7CiAgICBpbnQgbGlzdGVuZXIsIHNlcnZlciwgY2xpZW50
LCByZXQsIGVycm9yOwogICAgc3RydWN0IHNvY2thZGRyX2luIGFkZHIgPSB7MH07CiAgICBz
dHJ1Y3QgbGluZ2VyIGxpbmdlcjsKICAgIHN0cnVjdCBwb2xsZmQgcG9sbGZkOwogICAgdW5z
aWduZWQgaW50IGk7CiAgICBwdGhyZWFkX3QgdGhyZWFkOwogICAgc29ja2xlbl90IGxlbjsK
ICAgIGNoYXIgKmJ1ZmZlciA9IG1hbGxvYyhidWZmZXJfc2l6ZSk7CgogICAgbGlzdGVuZXIg
PSBzb2NrZXQoQUZfSU5FVCwgU09DS19TVFJFQU0sIElQUFJPVE9fVENQKTsKICAgIGNsaWVu
dCA9IHNvY2tldChBRl9JTkVULCBTT0NLX1NUUkVBTSwgSVBQUk9UT19UQ1ApOwoKICAgIHJl
dCA9IGdldHNvY2tuYW1lKGxpc3RlbmVyLCAoc3RydWN0IHNvY2thZGRyICopJmFkZHIsICZs
ZW4pOwogICAgcHJpbnRmKCJnZXRzb2NrbmFtZSAtPiAlZCwgeyV1LCAlI3h9LCAlc1xuIiwg
cmV0LCBhZGRyLnNpbl9mYW1pbHksIGFkZHIuc2luX2FkZHIuc19hZGRyLCBzdHJlcnJvcihl
cnJubykpOwogICAgYWRkci5zaW5fZmFtaWx5ID0gQUZfSU5FVDsKICAgIGFkZHIuc2luX2Fk
ZHIuc19hZGRyID0gaW5ldF9hZGRyKCIxMjcuMC4wLjEiKTsKICAgIHJldCA9IGJpbmQobGlz
dGVuZXIsIChzdHJ1Y3Qgc29ja2FkZHIgKikmYWRkciwgc2l6ZW9mKGFkZHIpKTsKICAgIGlm
IChyZXQgPCAwKQogICAgICAgIHByaW50ZigiYmluZCAtPiAlZCwgJXNcbiIsIHJldCwgc3Ry
ZXJyb3IoZXJybm8pKTsKICAgIGxlbiA9IHNpemVvZihhZGRyKTsKICAgIHJldCA9IGdldHNv
Y2tuYW1lKGxpc3RlbmVyLCAoc3RydWN0IHNvY2thZGRyICopJmFkZHIsICZsZW4pOwogICAg
aWYgKHJldCA8IDApCiAgICAgICAgcHJpbnRmKCJnZXRzb2NrbmFtZSAtPiAlZCwgJXNcbiIs
IHJldCwgc3RyZXJyb3IoZXJybm8pKTsKICAgIHJldCA9IGxpc3RlbihsaXN0ZW5lciwgMSk7
CiAgICBpZiAocmV0IDwgMCkKICAgICAgICBwcmludGYoImxpc3RlbiAtPiAlZCwgJXNcbiIs
IHJldCwgc3RyZXJyb3IoZXJybm8pKTsKCiAgICByZXQgPSBjb25uZWN0KGNsaWVudCwgJmFk
ZHIsIHNpemVvZihhZGRyKSk7CiAgICBpZiAocmV0IDwgMCkKICAgICAgICBwcmludGYoImNv
bm5lY3QgLT4gJWQsICVzXG4iLCByZXQsIHN0cmVycm9yKGVycm5vKSk7CgogICAgc2VydmVy
ID0gYWNjZXB0NChsaXN0ZW5lciwgKHN0cnVjdCBzb2NrYWRkciAqKSZhZGRyLCAmbGVuLCBT
T0NLX05PTkJMT0NLKTsKICAgIGlmIChzZXJ2ZXIgPCAwKQogICAgICAgIHByaW50ZigiYWNj
ZXB0IC0+ICVkLCAlc1xuIiwgc2VydmVyLCBzdHJlcnJvcihlcnJubykpOwoKICAgIHJldCA9
IHNlbmQoY2xpZW50LCAiQSIsIDEsIE1TR19PT0IpOwogICAgaWYgKHJldCAhPSAxKQogICAg
ICAgIHByaW50Zigic2VuZCAtPiAlZCwgJXNcbiIsIHJldCwgc3RyZXJyb3IoZXJybm8pKTsK
CiAgICByZXQgPSByZWN2KHNlcnZlciwgYnVmZmVyLCBidWZmZXJfc2l6ZSwgTVNHX09PQik7
CiAgICBpZiAocmV0ICE9IDEpCiAgICAgICAgcHJpbnRmKCJyZWN2IC0+ICVkLCAlc1xuIiwg
cmV0LCBzdHJlcnJvcihlcnJubykpOwoKICAgIGlmICgwKQogICAgewogICAgcmV0ID0gcmVj
dihzZXJ2ZXIsIGJ1ZmZlciwgYnVmZmVyX3NpemUsIDApOwogICAgaWYgKHJldCAhPSAxKQog
ICAgICAgIHByaW50ZigicmVjdiAjMyAtPiAlZCwgJXNcbiIsIHJldCwgc3RyZXJyb3IoZXJy
bm8pKTsKICAgIH0KCiAgICBwb2xsZmQuZmQgPSBzZXJ2ZXI7CiAgICBwb2xsZmQuZXZlbnRz
ID0gUE9MTElOIHwgUE9MTFBSSTsKICAgIHJldCA9IHBvbGwoJnBvbGxmZCwgMSwgMCk7CiAg
ICBwcmludGYoInBvbGwgLT4gJWQsICUjeFxuIiwgcmV0LCBwb2xsZmQucmV2ZW50cyk7Cgog
ICAgcmV0ID0gMTsKICAgIHJldCA9IHNldHNvY2tvcHQoc2VydmVyLCBTT0xfU09DS0VULCBT
T19PT0JJTkxJTkUsICZyZXQsIHNpemVvZihyZXQpKTsKICAgIGlmIChyZXQgPCAwKQogICAg
ICAgIHByaW50Zigic2V0c29ja29wdCAtPiAlZCwgJXNcbiIsIHJldCwgc3RyZXJyb3IoZXJy
bm8pKTsKCiAgICBwb2xsZmQuZmQgPSBzZXJ2ZXI7CiAgICBwb2xsZmQuZXZlbnRzID0gUE9M
TElOIHwgUE9MTFBSSTsKICAgIHJldCA9IHBvbGwoJnBvbGxmZCwgMSwgMCk7CiAgICBwcmlu
dGYoInBvbGwgLT4gJWQsICUjeFxuIiwgcmV0LCBwb2xsZmQucmV2ZW50cyk7CgogICAgcmV0
ID0gcmVjdihzZXJ2ZXIsIGJ1ZmZlciwgYnVmZmVyX3NpemUsIDApOwogICAgaWYgKHJldCAh
PSAxKQogICAgICAgIHByaW50ZigicmVjdiAjMyAtPiAlZCwgJXNcbiIsIHJldCwgc3RyZXJy
b3IoZXJybm8pKTsKCiAgICByZXR1cm4gMDsKfQo=

--------------0NTVpZ37c6VtgZo4QOoydsn7--
