Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DF94E91C2
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 11:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbiC1Juq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 05:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239941AbiC1Jup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 05:50:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F5F41F9E;
        Mon, 28 Mar 2022 02:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=/93dChLt+Za1uKCUhSTu2aRMCha+vAJZKphFzk7McsE=;
        t=1648460942; x=1649670542; b=GrQqsPGmXslqKPkkMv5L9TKn0aHOqHUDd7Mwgbobfr+0/wj
        ZfRjwz5YxIiiphH2lJt0/j4nocADL6fH/wGwU0+eI/w/2NOg6NhhOGFUtGK+kLkkJ2jVdMxCuTmFS
        J3wqwMkDf3QphTt5Jx5M/CJzEsRRhwX2YRo4mRBNobtPwgt/VyA/7JtAhpxcAUyiFGkeUz7b9ZaAG
        DxIUHDdw/HVcbQ8Xjd8AyY2Ry+4ecO6/1wxFkPV8y2e24sPYClwRmqXlOOdyDtXQc8RzEzsZNUb7t
        KGzPMRop5JNPlDKyDrX4Lh3CslI/XWA8uWx9DKPodItgWYXUmO+/e8lHJgyLgxxA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nYlzJ-001WuR-EZ;
        Mon, 28 Mar 2022 11:48:37 +0200
Message-ID: <f94c4fc26251262de0ecab003c74833617c1b305.camel@sipsolutions.net>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Date:   Mon, 28 Mar 2022 11:48:36 +0200
In-Reply-To: <20220327051502.63fde20a.pasic@linux.ibm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
         <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
         <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
         <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
         <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
         <20220324163132.GB26098@lst.de>
         <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
         <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
         <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
         <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
         <298f4f9ccad7c3308d3a1fd8b4b4740571305204.camel@sipsolutions.net>
         <CAHk-=whXAan2ExANMryPSFaBWeyzikPi+fPUseMoVhQAxR7cEA@mail.gmail.com>
         <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
         <20220327051502.63fde20a.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-03-27 at 05:15 +0200, Halil Pasic wrote:

> 
> The key here is "sync_sg API, all the parameters must be the same
> as those passed into the single mapping API", but I have to admit,
> I don't understand the *single* in here.
> 

Hah. So I wasn't imagining things after all.

However, as the rest of the thread arrives, this still means it's all
broken ... :)

> The intended meaning of the
> last sentence is that one can do partial sync by choose 
> dma_hande_sync, size_sync such that dma_handle_mapping <= dma_handle_sync
> < dma_handle_mapping + size_mapping and dma_handle_sync + size_sync <=
> dma_handle_mapping + size_mapping. But the direction has to remain the
> same.

Right.

> BTW, the current documented definition of the direction is about the
> data transfer direction between memory and the device, and how the CPU
> is interacting with the memory is not in scope. A quote form the
> documentation.
> 
> """
> ======================= =============================================
> DMA_NONE                no direction (used for debugging)
> DMA_TO_DEVICE           data is going from the memory to the device
> DMA_FROM_DEVICE         data is coming from the device to the memory
> DMA_BIDIRECTIONAL       direction isn't known
> ======================= =============================================
> """
> (Documentation/core-api/dma-api.rst)
> 
> My feeling is, that re-defining the dma direction is not a good idea. But
> I don't think my opinion has much weight here.

However, this basically means that the direction argument to the flush
APIs are completely useless, and we do have to define something
new/else...

johannes
