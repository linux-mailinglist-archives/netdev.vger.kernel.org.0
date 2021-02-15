Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378E431BFD6
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhBOQyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:54:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53452 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhBOQxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:53:25 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lBh75-0001vr-PW; Mon, 15 Feb 2021 16:52:43 +0000
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: octeontx2-af: cn10k: MAC internal loopback support
Message-ID: <bbb47971-22f5-9392-fcdc-bdd068883f27@canonical.com>
Date:   Mon, 15 Feb 2021 16:52:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis on linux-next today using Coverity found an issue in the
following commit:

commit 3ad3f8f93c81f81d6e28b2e286b03669cc1fb3b0
Author: Hariprasad Kelam <hkelam@marvell.com>
Date:   Thu Feb 11 21:28:34 2021 +0530

    octeontx2-af: cn10k: MAC internal loopback support

The analysis is as follows:

723 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
724 {
725        struct mac_ops *mac_ops;

   1. var_decl: Declaring variable lmac_id without initializer.

726        u8 cgx_id, lmac_id;
727

   2. Condition !is_cgx_config_permitted(rvu, pcifunc), taking false branch.

728        if (!is_cgx_config_permitted(rvu, pcifunc))
729                return -EPERM;
730

    Uninitialized scalar variable (UNINIT)

731        mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
732

   Uninitialized scalar variable (UNINIT)
   3. uninit_use_in_call: Using uninitialized value lmac_id when calling
*mac_ops->mac_lmac_intl_lbk.

733        return mac_ops->mac_lmac_intl_lbk(rvu_cgx_pdata(cgx_id, rvu),
734                                          lmac_id, en);
735 }

Variables cgx_id and lmac_id are no longer being initialized and garbage
values are being passed into function calls.  Originally, these
variables were being initialized with a call to rvu_get_cgx_lmac_id()
but that has now been removed.

Colin
