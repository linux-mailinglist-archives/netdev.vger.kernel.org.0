Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA27131ECE
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 06:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgAGFPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 00:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgAGFPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 00:15:25 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 214E7207FD;
        Tue,  7 Jan 2020 05:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578374124;
        bh=7IRn73LOcIxtOPF38vt+jdde9KSqRJ/hkO43TQ+PV6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dnpAH75AkRY/1sigQosliNYb44fjXUGI2Xe+Dafae7NTasmhJWZx+xPPtruGzof9z
         ekmuxXw3RYrNLLwaqyFrIQ2MDeGdHqUhMO/aBvrxvBjJb4RYfgduqd6DFtDSNZ7i++
         Gt/q+ebKKUIWAqAO7XQIDe03Tvpx6CNDuA2Yb8dk=
Date:   Mon, 6 Jan 2020 21:15:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code
 check
Message-ID: <20200107051521.GF705@sol.localdomain>
References: <20200106045833.1725-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106045833.1725-1-masahiroy@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 01:58:33PM +0900, Masahiro Yamada wrote:
> 'PTR_ERR(p) == -E*' is a stronger condition than IS_ERR(p).
> Hence, IS_ERR(p) is unneeded.
> 
> The semantic patch that generates this commit is as follows:
> 
> // <smpl>
> @@
> expression ptr;
> constant error_code;
> @@
> -IS_ERR(ptr) && (PTR_ERR(ptr) == - error_code)
> +PTR_ERR(ptr) == - error_code
> // </smpl>
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Any reason for not doing instead:

	ptr == ERR_PTR(-error_code)

?  To me it seems weird to use PTR_ERR() on non-error pointers.  I even had to
double check that it returns a 'long' and not an 'int'.  (If it returned an
'int', it wouldn't work...)

- Eric
