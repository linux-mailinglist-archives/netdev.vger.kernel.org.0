Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C972134491B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhCVPTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhCVPTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:19:33 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3CE1C061574;
        Mon, 22 Mar 2021 08:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
        bh=M/guEIufcLH5UC0PBcvJKM9kuq1NcvG3o6LyL50MkJg=; b=I1ikYb8N7F6qS
        1FW0UYCCekk0dy2PNYJsSn8ff94dJLMUY56svsXmvYlisOKcGStRksxlNjIlR0Hz
        42H5nDClHVST63eimi06A3YzQJYK+u5j36apcZI4sbZw6NgcG5cr4GKxZo0M3fMX
        lL4JP8J2oOmM6zpFsk5sS73LUkAut8=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Mon, 22 Mar
 2021 23:19:07 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Mon, 22 Mar 2021 23:19:07 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Bug] qlogic/qlcnic: Report a potential use after free in
 qlcnic_probe
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
X-SendMailWithSms: false
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2c78e078.b81d.1785a84ab33.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygBXXkprtVhg4HQOAA--.2W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsIBlQhn5UKXQAAss
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
    my static analyzer tool reported a potential uaf in qlcnic_probe.

The problem file is drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c in
Linux Kernel-5.12-rc2.

In funtion qlcnic_probe around line 2623,  it calls qlcnic_dcb_enable() 
to enable adapter->dcb. But the adapter->dcb could be freed inside
this callee when qlcnic_dcb_attach(dcb) return non-zero. 

Later the adapter->dcb is used by qlcnic_dcb_get_info(adapter->dcb) 
and could cause a use after free.

Thanks for your time.




