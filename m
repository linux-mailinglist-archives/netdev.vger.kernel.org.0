Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6D34E91EB
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 11:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiC1Jw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 05:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240015AbiC1Jwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 05:52:50 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D504F477;
        Mon, 28 Mar 2022 02:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=nJO5E5YD857Be4i83ypHN59i/VCIHMrXJalTXZF8ChM=;
        t=1648461070; x=1649670670; b=yK20yxadnBzN8+9B1mQwJU3zPiDgzvgZdc6u8IMOow3L36F
        JN7CgNZvilXkGCxHZF3v6gt8pCZRES6bh4hP4gsxSuNeSuEJCG3DTpkSLLQ9dscCS0MqHoSvmjibe
        nCyBHIPgyrCibtGVlDv45CQbNwt0wJityVt1jRZzfomB8sptqE7XqKUm03wjBAz6RdsyTf2jJkVYH
        oV+6U/yWl/7iZIAwTENCotrfMAEnsWrdPzvBdMpZksjbjyldCmVxKdPyb0723wZd3ZBIxgzE24ZjO
        6pQTptAn6sIMyGZU+iIuB1eHqvW9/BWUPuw7+62LJoQe1pnnvcmoLmOSNGemSIvA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nYm1Y-001X37-2H;
        Mon, 28 Mar 2022 11:50:56 +0200
Message-ID: <bf9a4949635c01c5dec53b0e873eccec4e2b0d33.camel@sipsolutions.net>
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
Date:   Mon, 28 Mar 2022 11:50:54 +0200
In-Reply-To: <f94c4fc26251262de0ecab003c74833617c1b305.camel@sipsolutions.net>
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
         <f94c4fc26251262de0ecab003c74833617c1b305.camel@sipsolutions.net>
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

On Mon, 2022-03-28 at 11:48 +0200, Johannes Berg wrote:
> 
> However, this basically means that the direction argument to the flush
> APIs are completely useless, and we do have to define something
> new/else...
> 

No I worded that badly - the direction isn't useless, but thinking of it
in terms of a buffer property rather than data movement is inaccurate.
So then if we need something else to indicate how data was expected to
be moved, the direction argument becomes useless, since it's not a
buffer property but rather a temporal thing on a specific place that
expected certain data movement.

johannes
