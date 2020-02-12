Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4541015B140
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgBLTln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:41:43 -0500
Received: from smtp.noc-kru.de ([88.218.226.4]:39301 "EHLO smtp.noc-kru.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgBLTln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 14:41:43 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 14:41:41 EST
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mx.noc-kru.de (Postfix) with ESMTP id C2BE15A2199;
        Wed, 12 Feb 2020 20:32:35 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at idefix.krude.de
Received: from smtp.noc-kru.de ([88.218.226.4])
        by localhost (idefix.noc-kru.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JVfAgvFchAtr; Wed, 12 Feb 2020 20:32:33 +0100 (CET)
Received: from phlox.h.transitiv.net (2001-4dd0-2d41-0-d1dc-282-62ef-8fa2.ipv6dyn.netcologne.de [IPv6:2001:4dd0:2d41:0:d1dc:282:62ef:8fa2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by mx.noc-kru.de (Postfix) with ESMTPSA id 13F3F5A229E;
        Wed, 12 Feb 2020 20:32:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=krude.de; s=mail;
        t=1581535953; bh=1vmRLVZks48GT3ZVlDPxnXV5eHetAPhkCTAe9N3Qtxg=;
        h=Date:From:To:Cc:Subject:From;
        b=eW/iRqpV3rlUoNITwHSxS0QXKIs8HLqajq+M2MNdMwofEcn/SG8X7W6AEjso5yuDr
         FOEMusYTUwK9zL2JDgJGTKoFS3kdL4X7fuyGdyzCR+7OKJSO+1hWhjOnRtH0tKCVq2
         bWp3gyztgR0Qn23r0ysZdALSRktWWe2gDUtWmF3g=
Date:   Wed, 12 Feb 2020 20:32:27 +0100
From:   Johannes Krude <johannes@krude.de>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        trivial@kernel.org
Subject: [PATCH] bpf_prog_offload_info_fill: replace bitwise AND by logical
 AND
Message-ID: <20200212193227.GA3769@phlox.h.transitiv.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This if guards whether user-space wants a copy of the offload-jited
bytecode and whether this bytecode exists. By erroneously doing a bitwise
AND instead of a logical AND on user- and kernel-space buffer-size can lead
to no data being copied to user-space especially when user-space size is a
power of two and bigger then the kernel-space buffer.

Signed-off-by: Johannes Krude <johannes@krude.de>
---
 kernel/bpf/offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 2c5dc6541..bd09290e3 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -321,7 +321,7 @@ int bpf_prog_offload_info_fill(struct bpf_prog_info *info,
 
 	ulen = info->jited_prog_len;
 	info->jited_prog_len = aux->offload->jited_len;
-	if (info->jited_prog_len & ulen) {
+	if (info->jited_prog_len && ulen) {
 		uinsns = u64_to_user_ptr(info->jited_prog_insns);
 		ulen = min_t(u32, info->jited_prog_len, ulen);
 		if (copy_to_user(uinsns, aux->offload->jited_image, ulen)) {
-- 
2.24.0

