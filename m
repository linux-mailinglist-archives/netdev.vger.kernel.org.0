Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74819B7B67
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732278AbfISOA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:00:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731819AbfISOA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 10:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4/wowURew5p2RFwXZpB/zg4VRhbVIPf6o3XD4s1sVpY=; b=uCUP7ixp36gje4WHnFA/cHarNN
        z/yHXxtfAkoBitZsZn+U9m6B0D3+0SS1+8hLsTg/pghbfpx9hFzzNNfDQXhzycn88TJZZt+ifFnmO
        zhIdVXSeRWNX0kNS7N+uolf6uIv/MNjOjoCxBDrnoqkshlNV6bhQ/O1lLDoreehLbqJQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAwyv-0006RQ-4A; Thu, 19 Sep 2019 16:00:25 +0200
Date:   Thu, 19 Sep 2019 16:00:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 2/2][ethtool] ethtool: implement support for Energy
 Detect Power Down
Message-ID: <20190919140025.GC22556@lunn.ch>
References: <20190919100833.6208-1-alexandru.ardelean@analog.com>
 <20190919100833.6208-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919100833.6208-2-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
> +static int parse_named_uint(struct cmd_context *ctx, const char *name,
> +			    void *val, enum tunable_type_id type_id)
>  {
>  	if (ctx->argc < 2)
>  		return 0;
> @@ -5026,7 +5051,16 @@ static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
>  	if (strcmp(*ctx->argp, name))
>  		return 0;
>  
> -	*val = get_uint_range(*(ctx->argp + 1), 0, 0xff);
> +	switch (type_id) {
> +	case ETHTOOL_TUNABLE_U8:
> +		*(u8 *)val = get_uint_range(*(ctx->argp + 1), 0, 0xff);
> +		break;
> +	case ETHTOOL_TUNABLE_U16:
> +		*(u16 *)val = get_uint_range(*(ctx->argp + 1), 0, 0xffff);

I personally don't like these casts. Could you refactor this code in
some other way to avoid them. Make the parse_named_u8()
parse_named_u16() a bit fatter, and the shared code a bit slimmer?

Thanks
	Andrew
