Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B7C245A7
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 03:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfEUBcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 21:32:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbfEUBcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 21:32:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8FFEC602B7; Tue, 21 May 2019 01:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558402350;
        bh=jUBciQwDLO8DI/ZPhk5HhSoTVtSqS/+i48ZqN5DOVwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F47/6NMrbkhdAJ9MAogrobowwRLAa43aexBQxM2FzC/DbcjHMMhXAkYQDccVcOYrL
         Lo3XUC5vrv929pXKxtjGzFBzjGWqPA4Q6NYeiNiKz5RG8PmuFZGPXh9hd0kvnjCnZQ
         DZPNPlNrPDXWPZn7y9rwx811gwG6XSsKuTUSMlf4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 85C5A602B7;
        Tue, 21 May 2019 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558402349;
        bh=jUBciQwDLO8DI/ZPhk5HhSoTVtSqS/+i48ZqN5DOVwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h307RjJc9xkBcbnBvEAcel6wzzP0lSQJmwqychQ0OK2jcvpNKzB+evEcy2FajZfZz
         y5AWG98+nUS1Kbj6zWQTquwNyIzxv13pm6e252k+Vf0iywk3GTe+Yd8CWLzAjOFcTh
         M6Fcpp54cyEfJOInaRF0yUB7joAZKpDXbaZREXac=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 20 May 2019 19:32:29 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Alex Elder <elder@linaro.org>
Cc:     arnd@arndb.de, david.brown@linaro.org, agross@kernel.org,
        davem@davemloft.net, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, evgreen@chromium.org, benchan@google.com,
        ejcaruso@google.com, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] net: qualcomm: rmnet: fix struct rmnet_map_header
In-Reply-To: <81fd1e01-b8e3-f86a-fcc9-2bcbc51bd679@linaro.org>
References: <20190520135354.18628-1-elder@linaro.org>
 <20190520135354.18628-2-elder@linaro.org>
 <b0edef36555877350cfbab2248f8baac@codeaurora.org>
 <81fd1e01-b8e3-f86a-fcc9-2bcbc51bd679@linaro.org>
Message-ID: <d90f8ccdc1f76f9166f269eb71a14f7f@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> If the above illustration is supposed to be in network byte order,
>> then it is wrong. The documentation has the definition for the MAP
>> packet.
> 
> Network *bit* order is irrelevant to the host.  Host memory is
> byte addressable only, and bit 0 is the low-order bit.
> 
>> Packet format -
>> 
>> Bit             0             1           2-7      8 - 15           16 
>> - 31
>> Function   Command / Data   Reserved     Pad   Multiplexer ID    
>> Payload length
>> Bit            32 - x
>> Function     Raw  Bytes
> 
> I don't know how to interpret this.  Are you saying that the low-
> order bit of the first byte is the command/data flag?  Or is it
> the high-order bit of the first byte?
> 
> I'm saying that what I observed when building the code was that
> as originally defined, the cd_bit field was the high-order bit
> (bit 7) of the first byte, which I understand to be wrong.
> 
> If you are telling me that the command/data flag resides at bit
> 7 of the first byte, I will update the field masks in a later
> patch in this series to reflect that.
> 

Higher order bit is Command / Data.

>> The driver was written assuming that the host was running ARM64, so
>> the structs are little endian. (I should have made it compatible
>> with big and little endian earlier so that is my fault).
> 
> Little endian and big endian have no bearing on the host's
> interpretation of bits within a byte.
> 
> Please clarify.  I want the patches to be correct, and what
> you're explaining doesn't really straighten things out for me.
> 
> 					-Alex

Can't this bitfields just be used similar to how struct tcphdr &
iphdr are currently defined. That way, you dont have to make
these many changes.

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h 
b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 884f1f5..302d1db 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -40,9 +40,17 @@ enum rmnet_map_commands {
  };

  struct rmnet_map_header {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
         u8  pad_len:6;
         u8  reserved_bit:1;
         u8  cd_bit:1;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+       u8  cd_bit:1;
+       u8  reserved_bit:1;
+       u8  pad_len:6;
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
         u8  mux_id;
         __be16 pkt_len;
  }  __aligned(1);


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
