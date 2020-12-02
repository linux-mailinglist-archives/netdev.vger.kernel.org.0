Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3C42CB3FC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgLBEmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgLBEmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 23:42:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F202C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 20:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=3cggifz4mFXwWHg6c4q1EM6G0raIF5MaCc7PD/3Ay6w=; b=ESHiCXuEdWYjJ4VTztSuVTu9rw
        vOgGSbKJL39ZHBdKuQOBpPzP30yrJAygjCn1eFAIx3zoMHdlaVN47LdBzRjZXyLEB4KYSDTaIbflg
        XKHPBXAJUnM92QQnTe8ssTEroPKwxpJm21lK+0kQUnAsO1Xm+U0Pmh4bmX/8UayAM7yvKtv1AM2EP
        GLVpI/z6GD+YASsAA20s/1FZzvRm9/IWi1x9iu3qXfdatTzYJW4Be/Z5+xY8R58wWXKXrm4ft5xBK
        SOOKR8MDXUadymXFrNE1RAne40PHLYvEngVJ2y4gncD6tRR8jw0nwJsdvAa/ici143uyFDyBrWpl+
        ZFl7Z1WA==;
Received: from [2601:1c0:6280:3f0::1494]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkJxE-0001vr-TJ; Wed, 02 Dec 2020 04:41:26 +0000
Subject: Re: [net:master 1/3] ERROR: modpost: "__uio_register_device"
 undefined!
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <202012021229.9PwxJvFJ-lkp@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8875896f-81a7-cbda-3b6e-97b5b22383c3@infradead.org>
Date:   Tue, 1 Dec 2020 20:41:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <202012021229.9PwxJvFJ-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20 8:01 PM, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> head:   2867e1eac61016f59b3d730e3f7aa488e186e917
> commit: 14483cbf040fcb38113497161088a1ce8ce5d713 [1/3] net: broadcom CNIC: requires MMU
> config: microblaze-randconfig-r011-20201201 (attached as .config)
> compiler: microblaze-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=14483cbf040fcb38113497161088a1ce8ce5d713
>         git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
>         git fetch --no-tags net master
>         git checkout 14483cbf040fcb38113497161088a1ce8ce5d713
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=microblaze 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
>>> ERROR: modpost: "__uio_register_device" [drivers/net/ethernet/broadcom/cnic.ko] undefined!
>>> ERROR: modpost: "uio_unregister_device" [drivers/net/ethernet/broadcom/cnic.ko] undefined!
>>> ERROR: modpost: "uio_event_notify" [drivers/net/ethernet/broadcom/cnic.ko] undefined!
> 
> ---

Jakub,

This happens due to CONFIG_SCSI_BNX2_ISCSI=m, which selects CNIC
when it shouldn't.

Martin Petersen has already merged the SCSI patch for this (for 5.11,
sadly):

https://lore.kernel.org/lkml/20201129070916.3919-1-rdunlap@infradead.org/


Maybe I should have sent them to one or both of you as a 2-patch series (?).

What should we do next?


Sorry about this. Thanks.

-- 
~Randy

