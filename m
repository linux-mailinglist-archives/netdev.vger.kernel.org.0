Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B223B1F8E78
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 08:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgFOGtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 02:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbgFOGrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 02:47:12 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880E620739;
        Mon, 15 Jun 2020 06:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592203631;
        bh=GHrKaLhO/989idTWGwHGPWFsd6gCI+ixIZgFs90bt20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDwl+ulFQW/KmE6Xzt91HhVRBm3lRrVudTs1h1sZjRASUvcq2yYPR+V9bZ+gV8TMd
         esFcM19vrWA7OEzveYe91Cy+vLvU03frQJnq2NBkEB0xjfyN+oAMXCrJ0o3c3/myeM
         uR9/DlkGaEsiAmsYxPhKyK6ocNBDwhggQeGdrFXg=
Received: from mchehab by mail.kernel.org with local (Exim 4.93)
        (envelope-from <mchehab@kernel.org>)
        id 1jkith-009nmC-Fn; Mon, 15 Jun 2020 08:47:09 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: [PATCH 04/29] scripts/kernel-doc: parse __ETHTOOL_DECLARE_LINK_MODE_MASK
Date:   Mon, 15 Jun 2020 08:46:43 +0200
Message-Id: <a67f494ee12d8edb47b65f68ef1b66e2e4080d6d.1592203542.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592203542.git.mchehab+huawei@kernel.org>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __ETHTOOL_DECLARE_LINK_MODE_MASK macro is a variant of
DECLARE_BITMAP(), used by phylink.h. As we have already a
parser for DECLARE_BITMAP(), let's add one for this macro,
in order to avoid such warnings:

	./include/linux/phylink.h:54: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
	./include/linux/phylink.h:54: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 scripts/kernel-doc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index b4c963f8364e..43b8312363a5 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1083,7 +1083,9 @@ sub dump_struct($$) {
 	$members =~ s/\s*__packed\s*/ /gos;
 	$members =~ s/\s*CRYPTO_MINALIGN_ATTR/ /gos;
 	$members =~ s/\s*____cacheline_aligned_in_smp/ /gos;
+
 	# replace DECLARE_BITMAP
+	$members =~ s/__ETHTOOL_DECLARE_LINK_MODE_MASK\s*\(([^\)]+)\)/DECLARE_BITMAP($1, __ETHTOOL_LINK_MODE_MASK_NBITS)/gos;
 	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
 	# replace DECLARE_HASHTABLE
 	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
-- 
2.26.2

