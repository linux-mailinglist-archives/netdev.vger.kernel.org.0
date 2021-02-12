Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88F31A4A2
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhBLSkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:40:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhBLSkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:40:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F5164E35;
        Fri, 12 Feb 2021 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613155160;
        bh=Ufm1IuFuhAdeBsLqdtXYzu1q5PxT1sJg4ssgA1HNt7s=;
        h=Date:From:To:Cc:Subject:From;
        b=F19ZsdBgLpeO5ahduWjPIyY5tE+zbI51L8o7tKybu2UYb3sDlElvy/cpjmCWgqk8u
         cqF+iuHJnmAI8FW54hqCowWM7F0vkwvE1QIPosiFZpFvxNBUpkBkkaJGvHH4rh4aXn
         lq2iAdsAWwDgPdzBG/OMKLT91/faDHRYiboaHFQLHr9luC2MC76WkKz1Cu17hcklsG
         Ji4ZNJu6i8XVVK7lT/a0CDONcbM4aWLKjLFVwZFIixxUrX3ysCzI/sgclbyWc5C35R
         txgLVV2MuFK23RfIgP3DWPQIINvXUixmaTg0Wr6PvjpxHTjy1/U9vMR0pWD1q++zRX
         08x17kYVLkjmQ==
Date:   Fri, 12 Feb 2021 12:39:17 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [bug report] octeontx2-af: cn10k: Uninitialized variables
Message-ID: <20210212183917.GA279621@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Variables cgx_id and lmac_id are being used uninitialized at lines 731
and 733 in the following function:

723 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
724 {
725         struct mac_ops *mac_ops;
726         u8 cgx_id, lmac_id;
727
728         if (!is_cgx_config_permitted(rvu, pcifunc))
729                 return -EPERM;
730
731         mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
732
733         return mac_ops->mac_lmac_intl_lbk(rvu_cgx_pdata(cgx_id, rvu),
734                                           lmac_id, en);
735 }

This bug was introduced by commit 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support")

What's the right solution for this?

Thanks
--
Gustavo
