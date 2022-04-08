Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974954F9F65
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiDHWBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiDHWA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:00:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8B65BD1C;
        Fri,  8 Apr 2022 14:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C93BB82D84;
        Fri,  8 Apr 2022 21:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9488C385A1;
        Fri,  8 Apr 2022 21:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649455132;
        bh=5v7f7nYfHlvDG7AYfD46YhKWGVC/BXhTPeBtFep21gY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LJnasY96pbhi7F2fI2hFXWSAfK+xv92mltT+uAD2mzVJeLEosYGzzPa/qy0ZbPrif
         wTkSw9hnFdPvHo7sHUQqCxm3h7cSw8VZYOKh5bc8Z8yPv1jQHM/Nu0DVKpSkuXFzUS
         k6EYzMlYAHHFquNf/EeloDWGH1JJ8chBpnpRyXs4UHmxmeb5zDlCAgxa+sB1s3VX5k
         ILJrrLfyPydjLeGP+vioaTw/h6f7rr5cms+UDs25UsFTZ/mg7r4Yu/BGmGEox2zPVL
         MblOZ2tIikvFscY1DAjbhPk3NtaK+6dtc5lWVmAQEaJvdrAZovUd5h3EHFIU/u235x
         00tGZJBdY2Xeg==
Date:   Fri, 8 Apr 2022 14:58:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <wangjie125@huawei.com>
Subject: Re: [PATCH net-next 2/3] net: ethtool: move checks before
 rtnl_lock() in ethnl_set_rings
Message-ID: <20220408145850.2c5882ec@kernel.org>
In-Reply-To: <20220408071245.40554-3-huangguangbin2@huawei.com>
References: <20220408071245.40554-1-huangguangbin2@huawei.com>
        <20220408071245.40554-3-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Apr 2022 15:12:44 +0800 Guangbin Huang wrote:
> +	if (tb[ETHTOOL_A_RINGS_RX_BUF_LEN] &&
> +	    nla_get_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN]) != 0 &&

I think we can drop the value checking. If attribute is present and
drivers doesn't support - reject. I don't think that would require 
any changes to existing user space but please double check.

> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
> +		ret = -EOPNOTSUPP;
> +		NL_SET_ERR_MSG_ATTR(info->extack,
> +				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
> +				    "setting rx buf len not supported");
> +		goto out_dev;
> +	}
> +
> +	if (tb[ETHTOOL_A_RINGS_CQE_SIZE] &&
> +	    nla_get_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE]) &&
> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_CQE_SIZE)) {
> +		ret = -EOPNOTSUPP;
> +		NL_SET_ERR_MSG_ATTR(info->extack,
> +				    tb[ETHTOOL_A_RINGS_CQE_SIZE],
> +				    "setting cqe size not supported");
> +		goto out_dev;
> +	}
