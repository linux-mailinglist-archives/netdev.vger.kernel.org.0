Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50676489FD7
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 20:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243167AbiAJTGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 14:06:43 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:33430 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243153AbiAJTGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 14:06:42 -0500
Received: by mail-oi1-f171.google.com with SMTP id v124so12724165oie.0;
        Mon, 10 Jan 2022 11:06:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wwk6x/ZR37nweD32vHsQk5bV8DeKWS9G1MuQnQEcbQM=;
        b=RID7hQsGjXfnY+jTqoMDjNXaEjOJ6j2cCZz3CEqJN3aGzIJdy6+evg9D6AKIK+U4NZ
         3nkhdHXiK8i7VtLUi4dxMatdmDZvheVGwsmnoHRItNqQdRbdELBw3/ljOH25SgKFyhw3
         e5rEQFLfEzcp/GPjGkWUsZ0FnQJh5lpxK4Z7m0HXzduk+InrGQAcet9uPsmR3FqQigaL
         eLqFhar52sO1Cvh7ucex24CCgdTPtq6DmrL8M5CBB+Zv3o10BZTz47MHlgkmxwfHoC07
         tdoKCIFqSY8rPlKqaCWW79pS1zP74crIlshD23LwhWGt8jwk/j8PNTYgcr0Ph9pJYTP1
         Xvww==
X-Gm-Message-State: AOAM532rfj+LO6AZpE5wcvInYIL+8hZT7erq38kZYc+Sw8Nad+gy4pjz
        7OIfnyFgZJ3SdxV05xy24MU/Iznd8w==
X-Google-Smtp-Source: ABdhPJx5ZBjyXM4U8hax5nPjSCYA9zsja6YzyYe4DefjUE4k0aeTDsQSOoG5Ymd24O+VmO0kjBJV3w==
X-Received: by 2002:a05:6808:1a1e:: with SMTP id bk30mr663998oib.26.1641841601494;
        Mon, 10 Jan 2022 11:06:41 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q189sm656483oib.8.2022.01.10.11.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 11:06:40 -0800 (PST)
Received: (nullmailer pid 1302633 invoked by uid 1000);
        Mon, 10 Jan 2022 19:06:39 -0000
Date:   Mon, 10 Jan 2022 13:06:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 1/8] of: base: add of_parse_phandle_with_optional_args()
Message-ID: <YdyDv1/WbNi3CMbu@robh.at.kernel.org>
References: <20211228142549.1275412-1-michael@walle.cc>
 <20211228142549.1275412-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228142549.1275412-2-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 03:25:42PM +0100, Michael Walle wrote:
> Add a new variant of the of_parse_phandle_with_args() which treats the
> cells name as optional. If it's missing, it is assumed that the phandle
> has no arguments.
> 
> Up until now, a nvmem node didn't have any arguments, so all the device
> trees haven't any '#*-cells' property. But there is a need for an
> additional argument for the phandle, for which we need a '#*-cells'
> property. Therefore, we need to support nvmem nodes with and without
> this property.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/of/base.c  | 23 +++++++++++++++++++++++
>  include/linux/of.h | 12 ++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5b907600f5b0..fb28bb26276e 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1543,6 +1543,29 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
>  }
>  EXPORT_SYMBOL(of_parse_phandle_with_args);
>  
> +/**
> + * of_parse_phandle_with_optional_args() - Find a node pointed by phandle in a list
> + *
> + * Same as of_parse_phandle_args() except that if the cells_name property is
> + * not found, cell_count of 0 is assumed.
> + *
> + * This is used to useful, if you have a phandle which didn't have arguments
> + * before and thus doesn't have a '#*-cells' property but is now migrated to
> + * having arguments while retaining backwards compatibility.
> + */
> +int of_parse_phandle_with_optional_args(const struct device_node *np,
> +					const char *list_name,
> +					const char *cells_name, int index,
> +					struct of_phandle_args *out_args)
> +{
> +	if (index < 0)
> +		return -EINVAL;

I'm not sure why we didn't do this from the start, but just make index 
unsigned and then this check is not needed.

> +
> +	return __of_parse_phandle_with_args(np, list_name, cells_name,
> +					    0, index, out_args);
> +}
> +EXPORT_SYMBOL(of_parse_phandle_with_optional_args);


With the above, just make this static inline. Bonus points if you want 
to do the same changes on the other variants.

Rob
