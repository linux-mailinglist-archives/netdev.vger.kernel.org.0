Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FBC2C7A56
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 18:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgK2RgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 12:36:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgK2RgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 12:36:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjQbY-009NT4-Ol; Sun, 29 Nov 2020 18:35:20 +0100
Date:   Sun, 29 Nov 2020 18:35:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201129173520.GF2234159@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define SPX5_RD_(sparx5, id, tinst, tcnt,			\
> +		 gbase, ginst, gcnt, gwidth,			\
> +		 raddr, rinst, rcnt, rwidth)			\
> +	readl(spx5_addr((sparx5)->regs, id, tinst, tcnt,	\
> +			gbase, ginst, gcnt, gwidth,             \
> +			raddr, rinst, rcnt, rwidth))
> +
> +#define SPX5_INST_RD_(iomem, id, tinst, tcnt,			\
> +		      gbase, ginst, gcnt, gwidth,		\
> +		      raddr, rinst, rcnt, rwidth)		\
> +	readl(spx5_inst_addr(iomem,				\
> +			     gbase, ginst, gcnt, gwidth,	\
> +			     raddr, rinst, rcnt, rwidth))
> +
> +#define SPX5_WR_(val, sparx5, id, tinst, tcnt,			\
> +		 gbase, ginst, gcnt, gwidth,			\
> +		 raddr, rinst, rcnt, rwidth)			\
> +	writel(val, spx5_addr((sparx5)->regs, id, tinst, tcnt,	\
> +			      gbase, ginst, gcnt, gwidth,	\
> +			      raddr, rinst, rcnt, rwidth))
> +
> +#define SPX5_INST_WR_(val, iomem, id, tinst, tcnt,		\
> +		      gbase, ginst, gcnt, gwidth,		\
> +		      raddr, rinst, rcnt, rwidth)		\
> +	writel(val, spx5_inst_addr(iomem,			\
> +				   gbase, ginst, gcnt, gwidth,	\
> +				   raddr, rinst, rcnt, rwidth))
> +
> +#define SPX5_RMW_(val, mask, sparx5, id, tinst, tcnt,			\
> +		  gbase, ginst, gcnt, gwidth,				\
> +		  raddr, rinst, rcnt, rwidth)				\
> +	do {								\
> +		u32 _v_;						\
> +		u32 _m_ = mask;						\
> +		void __iomem *addr =					\
> +			spx5_addr((sparx5)->regs, id, tinst, tcnt,	\
> +				  gbase, ginst, gcnt, gwidth,		\
> +				  raddr, rinst, rcnt, rwidth);		\
> +		_v_ = readl(addr);					\
> +		_v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));		\
> +		writel(_v_, addr);					\
> +	} while (0)
> +
> +#define SPX5_INST_RMW_(val, mask, iomem, id, tinst, tcnt,		\
> +		       gbase, ginst, gcnt, gwidth,			\
> +		       raddr, rinst, rcnt, rwidth)			\
> +	do {								\
> +		u32 _v_;						\
> +		u32 _m_ = mask;						\
> +		void __iomem *addr =					\
> +			spx5_inst_addr(iomem,				\
> +				       gbase, ginst, gcnt, gwidth,	\
> +				       raddr, rinst, rcnt, rwidth);	\
> +		_v_ = readl(addr);					\
> +		_v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));		\
> +		writel(_v_, addr);					\
> +	} while (0)
> +
> +#define SPX5_REG_RD_(regaddr)			\
> +	readl(regaddr)
> +
> +#define SPX5_REG_WR_(val, regaddr)		\
> +	writel(val, regaddr)
> +
> +#define SPX5_REG_RMW_(val, mask, regaddr)		    \
> +	do {						    \
> +		u32 _v_;                                    \
> +		u32 _m_ = mask;				    \
> +		void __iomem *_r_ = regaddr;		    \
> +		_v_ = readl(_r_);			    \
> +		_v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));   \
> +		writel(_v_, _r_);			    \
> +	} while (0)
> +
> +#define SPX5_REG_GET_(sparx5, id, tinst, tcnt,			\
> +		      gbase, ginst, gcnt, gwidth,		\
> +		      raddr, rinst, rcnt, rwidth)		\
> +	spx5_addr((sparx5)->regs, id, tinst, tcnt,		\
> +		  gbase, ginst, gcnt, gwidth,			\
> +		  raddr, rinst, rcnt, rwidth)
> +
> +#define SPX5_RD(...)  SPX5_RD_(__VA_ARGS__)
> +#define SPX5_WR(...)  SPX5_WR_(__VA_ARGS__)
> +#define SPX5_RMW(...) SPX5_RMW_(__VA_ARGS__)
> +#define SPX5_INST_RD(...) SPX5_INST_RD_(__VA_ARGS__)
> +#define SPX5_INST_WR(...) SPX5_INST_WR_(__VA_ARGS__)
> +#define SPX5_INST_RMW(...) SPX5_INST_RMW_(__VA_ARGS__)
> +#define SPX5_INST_GET(sparx5, id, tinst) ((sparx5)->regs[(id) + (tinst)])
> +#define SPX5_REG_RMW(...) SPX5_REG_RMW_(__VA_ARGS__)
> +#define SPX5_REG_WR(...) SPX5_REG_WR_(__VA_ARGS__)
> +#define SPX5_REG_RD(...) SPX5_REG_RD_(__VA_ARGS__)
> +#define SPX5_REG_GET(...) SPX5_REG_GET_(__VA_ARGS__)

I don't see any reason for macro magic here. If this just left over
from HAL code? Please turn this all into functions.

     Andrew

