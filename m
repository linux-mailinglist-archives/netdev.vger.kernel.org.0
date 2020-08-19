Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB89624A207
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgHSOvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgHSOvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:51:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C23C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 07:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vJYkPBAEBN3NMbKDK8twcmvoXro2PdbMjHSgThhTD3c=; b=r6SskpKbOvC7CAks3csi4C1iyK
        CdHCk2Pb4Dwh00xWFvKaYMv+qxWWpx9E7xkZrLW/95KZbXaOQark+xKmIcPvu1p1C0DFlxEthk5WD
        V8+iHTnBpLpbd0ltDQ1dIGPY8b7/i6Zbz4uUAKdUefWczlRPihzrX/2B0t1gqyPfo4N5aOUzWvXd1
        pVcBNwktw6sAIqt3tJdN4YzV7n4UhROqjiUqNcCpkGiBeYFaZd6zT0APckLb8OCAkytyYsMAAKB3F
        9ckgCXRNipsUSf8cRGY/sDNPYeOt1Jy+tPBPfGZt4bEaaEC4I7gwpKz+HqB81vICjXN1gXTxyzgpi
        N9R06+VQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8PRJ-0007BZ-8S; Wed, 19 Aug 2020 14:51:45 +0000
Date:   Wed, 19 Aug 2020 15:51:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>
Subject: Re: ethernet/sfc/ warnings with 32-bit dma_addr_t
Message-ID: <20200819145145.GA27058@infradead.org>
References: <f8f07f47-4ba9-4fd6-1d22-9559e150bc2e@infradead.org>
 <79f8e049-e5b3-5b42-a600-b3025ad51adc@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79f8e049-e5b3-5b42-a600-b3025ad51adc@solarflare.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 11:37:00AM +0100, Edward Cree wrote:
> As far as I can tell, truncation to 32 bits is harmless ??? the
> ??called function (efx_init_io) already tries every mask from the
> ??passed one down to 32 bits in case of PCIe hardware limitations.

Which btw isn't needed.  These days dma_set_mask_and_coherent
and friends never fail because of a "too large" mask - it will
only fail in the rare case of a too small one.  So the two places
that set the dma mask could be simplified.
