Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C1F3372BE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhCKMfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhCKMew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:34:52 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53606C061574;
        Thu, 11 Mar 2021 04:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
        bh=ryfXHe18DN1UjZnxckhWgKsLfHZNN7X4RUYg2FqUcMo=; b=Uf6DLvNnY63HV
        LvMaIuLY6sE+wc+X9lW5C4SPDAy+V3Xd9m8xwAqQrgpYG6cN90XQVsRIihmS3PpM
        guwvCZNmp+Vp/WWi/1cEtcHP9qSqe1/MWdZVkeqfZ4CcnZxVKAQI5QK9AK1soyhf
        ER1p2tvr9b2J6OLePgZifs8UaZq2FQ=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Thu, 11 Mar
 2021 20:34:44 +0800 (GMT+08:00)
X-Originating-IP: [202.79.170.108]
Date:   Thu, 11 Mar 2021 20:34:44 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     paulus@samba.org, davem@davemloft.net
Cc:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] net/ppp: A use after free in ppp_unregister_channe
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
X-SendMailWithSms: false
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygCHiBhkDkpgRUoMAA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsRBlQhn5AN0QACs5
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

File: drivers/net/ppp/ppp_generic.c

In ppp_unregister_channel, pch could be freed in ppp_unbridge_channels()
but after that pch is still in use. Inside the function ppp_unbridge_channels,
if "pchbb == pch" is true and then pch will be freed.

I checked the commit history and found that this problem is introduced from
4cf476ced45d7 ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls").

I have no idea about how to generate a suitable patch, sorry.
