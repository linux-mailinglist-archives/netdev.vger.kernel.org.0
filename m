Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7413415EDA4
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgBNRfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:35:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390104AbgBNQF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FAC62187F;
        Fri, 14 Feb 2020 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696356;
        bh=UHTF/KQOikrcVa58Jc+AI++DU1+I2cfHGw4+SZ/+l5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZlOWs2zF8O5AX6ozp81PaH9fpAB376dRywT6vTw4ztjNVaNqFAZsmv0oWz24G2NQ
         UWWBkB8vADnUcuKyAsh2i7EjiL2AoFZ0JRDHoIvCeFRS+Dk+aLbXwv+eg2pPTLg9r4
         MfDbs63Ca5C0XhhBdxxFgBtC1gN1o7fIcF6J2QTc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild test robot <lkp@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Olof's autobuilder <build@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 189/459] isdn: don't mark kcapi_proc_exit as __exit
Date:   Fri, 14 Feb 2020 10:57:19 -0500
Message-Id: <20200214160149.11681-189-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b33bdf8020c94438269becc6dace9ed49257c4ba ]

As everybody pointed out by now, my patch to clean up CAPI introduced
a link time warning, as the two parts of the capi driver are now in
one module and the exit function may need to be called in the error
path of the init function:

>> WARNING: drivers/isdn/capi/kernelcapi.o(.text+0xea4): Section mismatch in reference from the function kcapi_exit() to the function .exit.text:kcapi_proc_exit()
   The function kcapi_exit() references a function in an exit section.
   Often the function kcapi_proc_exit() has valid usage outside the exit section
   and the fix is to remove the __exit annotation of kcapi_proc_exit.

Remove the incorrect __exit annotation.

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Olof's autobuilder <build@lixom.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20191216194909.1983639-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/capi/kcapi_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index c94bd12c0f7c6..28cd051f1dfd9 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -239,7 +239,7 @@ kcapi_proc_init(void)
 	proc_create_seq("capi/driver",       0, NULL, &seq_capi_driver_ops);
 }
 
-void __exit
+void
 kcapi_proc_exit(void)
 {
 	remove_proc_entry("capi/driver",       NULL);
-- 
2.20.1

