Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3091B60B95A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiJXUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiJXUI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:08:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F99CB4481;
        Mon, 24 Oct 2022 11:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=smrlip5a13obHQefsrQCDEQn5FVgi9wQ3jfaysBd41A=; b=NsKy3KADUVtTLDLcow8PjYW4Wo
        u6xSIAOYezInwqNo4+VT4wXNh9YuZGynjlYH9HyRLsxjXAu7kOE3YYpM5vo2KK5Pd+utDaLWiQbYC
        HRXXEhnWxE4UH/sbLmRBRQr0Xt9ABDoMTGEbbr4YxdTsO1AI5D+O2/MoLsnrLCzvQ/823wQayvkRq
        FhklZ7JXqNnbcsXc9bH5iJMN03RBwLg5kZ7KeA8EJBlppNQ3vcpgBt2Jj3NjIoakO14Nx+KJKtJ9m
        GrXYA5oVoFe3jLO7ovLun05d0vuXmlnCFUL7TNGWThrId8XaRc6F1+Ve1ZxMF/YkvUsUQ3HPSO1r2
        lA9+dfiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1omzUq-0026gk-I2; Mon, 24 Oct 2022 15:36:12 +0000
Date:   Mon, 24 Oct 2022 08:36:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [PATCH 06/12] swiotlb: Remove bounce buffer remapping for Hyper-V
Message-ID: <Y1aw7L5IdpjFpQvw@infradead.org>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-7-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666288635-72591-7-git-send-email-mikelley@microsoft.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:57:09AM -0700, Michael Kelley wrote:
> With changes to how Hyper-V guest VMs flip memory between private
> (encrypted) and shared (decrypted), creating a second kernel virtual
> mapping for shared memory is no longer necessary. Everything needed
> for the transition to shared is handled by set_memory_decrypted().
> 
> As such, remove swiotlb_unencrypted_base and the associated
> code.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>

I'm more than glad that we can kill this code:

Acked-by: Christoph Hellwig <hch@lst.de>
