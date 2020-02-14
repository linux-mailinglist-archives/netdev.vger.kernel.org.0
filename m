Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C069B15E573
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393964AbgBNQlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393222AbgBNQWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57AFB24758;
        Fri, 14 Feb 2020 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697356;
        bh=lhYkUkKhNIN5XzZ3oL3+l7aoO6QBE7b9lZ90yaiKQ40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4ZAHzlHmqwiCYcfl074cQv245fi1dNyiY6EOc7LiCJ9ZlOzTH4u5k6cAV0xlVCUB
         iSxbgAjQJfHxwAupyE5dt5CebmbQZqov5b2M8bAtinLXq5sxz4uXPPyN8Lu8+FRtyf
         3Jm/6os2XbOHLANOrx8XX7+YEFnJwchfvQ+1MykY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild test robot <lkp@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Olof's autobuilder <build@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 058/141] isdn: don't mark kcapi_proc_exit as __exit
Date:   Fri, 14 Feb 2020 11:19:58 -0500
Message-Id: <20200214162122.19794-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
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
index 68db3c5a10636..d6ca626219c93 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -309,7 +309,7 @@ kcapi_proc_init(void)
 	proc_create("capi/driver",       0, NULL, &proc_driver_ops);
 }
 
-void __exit
+void
 kcapi_proc_exit(void)
 {
 	remove_proc_entry("capi/driver",       NULL);
-- 
2.20.1

