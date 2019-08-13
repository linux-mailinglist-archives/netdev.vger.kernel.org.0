Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB9B8BED2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfHMQlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:41:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48470 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfHMQlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7HlWwLFzCOZ7QQzVMV27bTyBbuYurJG67TdGyoRs0fo=; b=MG4m3VyHxaBDt/hiB/6nJ65WT
        b9Emowpcs+4HzgPIxmnraEW2+NFya3pXsJqx0S8UbklD6unAQ440ZPfk/zs9iuo2ojw7YF3XpQNqU
        iWQLBbQAx3tKFWzwOmMqGdgMqVC4dkSROVMEOa+09M/2vCct8HDQwhsXjUpVAkljtlKuwE1fG20VN
        HJxyfbbJrM+FgMUi0BFqDeZQGMvItaJU5kREdwtYCZTrNVG98Ys6PLgUbVWzroCggRKDKodRocPuB
        2a1h94b6GBDUPat/0+u1o1LGSsIScGeECk/QhTkMpWqbOxzKJ6DY4oAmPhzadn3POONzyq6oDZlyI
        cx9F5vrwg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxZr7-0000hw-Tj; Tue, 13 Aug 2019 16:41:05 +0000
Date:   Tue, 13 Aug 2019 09:41:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190813164105.GD22640@infradead.org>
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <20190812130252.GE24457@ziepe.ca>
 <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
 <20190813115707.GC29508@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813115707.GC29508@ziepe.ca>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 08:57:07AM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 13, 2019 at 04:31:07PM +0800, Jason Wang wrote:
> 
> > What kind of issues do you see? Spinlock is to synchronize GUP with MMU
> > notifier in this series.
> 
> A GUP that can't sleep can't pagefault which makes it a really weird
> pattern

get_user_pages/get_user_pages_fast must not be called under a spinlock.
We have the somewhat misnamed __get_user_page_fast that just does a
lookup for existing pages and never faults for a few places that need
to do that lookup from contexts where we can't sleep.
