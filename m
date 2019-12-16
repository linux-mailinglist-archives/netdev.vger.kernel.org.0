Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6837121A37
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLPTtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:49:31 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:39581 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLPTtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:49:31 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MbizQ-1i88iB1KcI-00dHi0; Mon, 16 Dec 2019 20:49:17 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild test robot <lkp@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Olof's autobuilder <build@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Karsten Keil <isdn@linux-pingi.de>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [staging-next] isdn: don't mark kcapi_proc_exit as __exit
Date:   Mon, 16 Dec 2019 20:48:56 +0100
Message-Id: <20191216194909.1983639-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AwV4AqFxQtvHHuFtYDOmzzpO+UtCki+y5x1+qgMNBZ3auzo2P61
 n80SihI9jUKtxW5+SH3BB2WX3IVdpMMeQLYNiFo+cpJnIanhLyr/UUNTUjAOxhZdyOM57xs
 2OyNoVoDoxuP0/ywztpVoUdOXkzctQYvXqIwcAz7eXKrvf+B5R9qh7PfewFlnh3aMZ158mx
 XBMK8B6dod8uxR+8xzSww==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FBvOzmlMejA=:CS+zCmdx1cBPOe0WA3ynhW
 35fNy4EIZ+Qxn9p3JHIaj9ZisVTYicDewM210gJ9I2Lc3ArteeK6yZOPc9k4ZzXwh9sITe4fU
 snKAt7jOmXKjRudzFIREHcUMUyrxpsmhWasDKe2a9qIlP/XtxffaEVMdFH1aawxQjiQZxwult
 YGSyq0SOI1P+QERdhsbnRcgDm/TaIKeEljuC6cd4jgLfHnWsmpjDt8HTdLpNFWY2amZSB0LYY
 axItxzXaNW9hxjdo+seBWoBjhne8HHzlZ5aMRo1Mt1IlGlnszzhygh9KtEyi4QdT7YLaL68GH
 WCeUOfLlmgry/NMvjcyH/cE9PyDOTpfouED4JM/gjrao1WFHlXkTmRdL5+cZlcotIS/kB7MmU
 N9pw2kDrUNiDL3a40eF2baLf7umo1e5XGAV774QRff3TkjY85NyqJugvcnPS/L06zAuryODlG
 0NL4kxWHTR7dsDrFmZ7MWOX5AbHDmFmGQBMPlIUikjSIiqAvPghnMCZwtJsf7KRLsHA6fkxgJ
 XBacbJ7y3sJleG2Ot1im/oN1pL7PkHJXMQNhqbVMmFSLZW6HnExTDUQ40D5/3eijY82wyy51E
 SLi4+wd8xdp92EURVhO34+bQqhe4U85bas/GhjiHHoauktpGKu84Foo+DKGRgs8oNTm52sKDb
 I3iOGYuuAlnsjLtezMsLiA6aw7p1yGIbdOqdKOd2WEmXveCvKFsz/Nvk8X5MBX9Eji2RacdtY
 ULm1mYC4fNtwNkaGoQkiL8eDUmN772K3Di4BL1L8XLb2KtWyniYEizknZyNf5oMyaSokASDaJ
 CdOjctYoP+CS4ywMKk+qT1HVEQdHymDLcL6N39Uf20EBzQ0bwb04s+M/JWbKMhhlge4IC6Csl
 pmG3TiNiVz3RbuDO1nPg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/isdn/capi/kcapi_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index 2bffbb8bf271..eadbe59b3753 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -217,7 +217,7 @@ kcapi_proc_init(void)
 	proc_create("capi/driver",           0, NULL, &empty_fops);
 }
 
-void __exit
+void
 kcapi_proc_exit(void)
 {
 	remove_proc_entry("capi/driver",       NULL);
-- 
2.20.0

