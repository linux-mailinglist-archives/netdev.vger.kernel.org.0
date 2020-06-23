Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1211204A9B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgFWHJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgFWHJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:09:21 -0400
Received: from mail.kernel.org (unknown [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661BF20774;
        Tue, 23 Jun 2020 07:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592896160;
        bh=cgffz8BCASr3lXXPg+dVmBMMDIINa1Dm7Cv2WHYeuAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNXilAsRLZ2QlF5vA4BsfsQHV0GJq+6ZWdFUzXhgKsHIEG/gpr6TQfZUFeYYsk0z5
         8R9XUexkbD6amV/dD5w6yh9I4de4PIVADgOOTtpMLk9ZdWeezgORTkVFe2xbCl3+/U
         lb9bpqbcKnRSQNTiLVGGYc4lcobvCeZDNcHPegFw=
Received: from mchehab by mail.kernel.org with local (Exim 4.93)
        (envelope-from <mchehab@kernel.org>)
        id 1jnd3R-003qj4-4a; Tue, 23 Jun 2020 09:09:13 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: [PATCH v2 06/15] scripts/kernel-doc: handle function pointer prototypes
Date:   Tue, 23 Jun 2020 09:09:02 +0200
Message-Id: <fec520dd731a273013ae06b7653a19c7d15b9562.1592895969.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592895969.git.mchehab+huawei@kernel.org>
References: <cover.1592895969.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some function pointer prototypes inside the net
includes, like this one:

	int (*pcs_config)(struct phylink_config *config, unsigned int mode,
			  phy_interface_t interface, const unsigned long *advertising);

There's nothing wrong using it with kernel-doc, but we need to
add a rule for it to parse such kind of prototype.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 scripts/kernel-doc | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 43b8312363a5..e991d7f961e9 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1771,6 +1771,11 @@ sub process_proto_function($$) {
 	$prototype =~ s@/\*.*?\*/@@gos;	# strip comments.
 	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
 	$prototype =~ s@^\s+@@gos; # strip leading spaces
+
+	 # Handle prototypes for function pointers like:
+	 # int (*pcs_config)(struct foo)
+	$prototype =~ s@^(\S+\s+)\(\s*\*(\S+)\)@$1$2@gos;
+
 	if ($prototype =~ /SYSCALL_DEFINE/) {
 		syscall_munge();
 	}
-- 
2.26.2

