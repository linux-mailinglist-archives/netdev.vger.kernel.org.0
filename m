Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04808497FF0
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242419AbiAXMt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:49:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:14200 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242536AbiAXMt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 07:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643028566; x=1674564566;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t5fxNB8z6pSku/t+EGOjDH0q4PUVYX8rnOSgZH4UVPU=;
  b=cWRe5CYLXk0Rjhw1QyNYaByNN2ZcxstHXPM2v1XhJpdC+xaJuT9Ny+LW
   E/H7/XMvhSwLb/fqijlU9dtDWbaW3xYESL+/VuMtrhCNVjHyDJNoesDWb
   KkW/fZ2MDLYIwXxIFIsZHER46ol+a0pwFXKa7X+gxH+gatQWRqDniEYrJ
   1nN/+0Df6KfSR1DgGT0qhDVXTGE22OlFJnaADXze46ZXdzxVXjib5A4PF
   116rwem/RKM/gRcm4odPp4qpp/paQ0AY+nqneAa4oZ6hUJUZuIRF/3aLr
   uJ0oThggWnu87MTG7EOMR4odQ/bJ7VZqwhh79S8tF1OuocgZ/QVTTyb8W
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="245817550"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="245817550"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 04:49:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="494607640"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 04:49:21 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nBylZ-00DtIl-85;
        Mon, 24 Jan 2022 14:48:13 +0200
Date:   Mon, 24 Jan 2022 14:48:12 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 33/54] net: ethernet: replace bitmap_weight with
 bitmap_weight_{eq,gt,ge,lt,le} for mellanox
Message-ID: <Ye6gDK2MA+cshctS@smile.fi.intel.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-34-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123183925.1052919-34-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 10:39:04AM -0800, Yury Norov wrote:
> Mellanox code uses bitmap_weight() to compare the weight of bitmap with
> a given number. We can do it more efficiently with bitmap_weight_{eq, ...}
> because conditional bitmap_weight may stop traversing the bitmap earlier,
> as soon as condition is met.

> -	if (port <= 0 || port > m)
> +	if (port <= 0 || bitmap_weight_lt(actv_ports.ports, dev->caps.num_ports, port))
>  		return -EINVAL;

Can we eliminate now the port <= 0 check? Or at least make it port == 0?

-- 
With Best Regards,
Andy Shevchenko


