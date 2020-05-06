Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C341C6FFE
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgEFMI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:08:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45947 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727792AbgEFMI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588766934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hAmivG5aDvvl7e+GYdcGOegOdLibFaOeKZvY0VQjVvw=;
        b=Plbwo/PE2+V4u6YvfBr1uAWPQoOVp/i7AUUJYYmDt0zGGJR/7kVy7fYyo51ZH1gwt6RINM
        b9uMqjIpz35Ll6Z3VqSFpbYK1YVh2VrfMVDsTwS7EdYQLptV8nfRe856ViWAxOs66iESCb
        5wJ549L9/cs56FSDsmvhJr8l6ipJQFU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-vAi11eHvOfuW6dbDRNUgGA-1; Wed, 06 May 2020 08:08:53 -0400
X-MC-Unique: vAi11eHvOfuW6dbDRNUgGA-1
Received: by mail-wr1-f71.google.com with SMTP id j16so1192212wrw.20
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hAmivG5aDvvl7e+GYdcGOegOdLibFaOeKZvY0VQjVvw=;
        b=nZxwYIL6nybkPwao/zTHEJGC/VjyvwM/DkxH69UNSoP+vmoozH5AL7uv2k1vMlZ2bj
         Nwn9qv5XI1YT7mNqjeq9Iswq2V8RIDAN+HtMwlje/PJ9fiVURXjwVgQgCPYh/5qpQ4+6
         ESBu0miB6scOwAuG9Hr7a0Eu9MIeTkVTXCrPeXZPQwLTRk3o+rCke+QY788kMr1SdR2s
         Q9H0vB0QpCbkMgzXmrP7DtlMaNuymA1F2tpOAU747wIlVuBBmEv0KygwDc+9SBlxwZSj
         yHvi+Zsgxf8kjG+rDH+27KLgZ3+DKikdFEqy22v2wEaccj7YFkyLp6Gz9/PZbH22EAIy
         oayw==
X-Gm-Message-State: AGi0Pub29ICtTJsv3o3Vgjd11ggRqEPesxPFA8PVaoHCAuvxCa9RBr36
        2zGz8JP90Z9v9bhLKgvh3uSYHkBFBCw6yA0hmWMbi6qX23Gc16u4nFO0wV4uwrNblG2SeHB+M+g
        oiWOcXGdMGuyLxcO8
X-Received: by 2002:a1c:f416:: with SMTP id z22mr4203995wma.32.1588766931869;
        Wed, 06 May 2020 05:08:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypJBsIQXXLBh7+polD0/FRHAo1jIr0FLeGcQ49ZR50oVFkk3bBSfh+noTe2EUmUQ7wGzC4gACg==
X-Received: by 2002:a1c:f416:: with SMTP id z22mr4203979wma.32.1588766931683;
        Wed, 06 May 2020 05:08:51 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id s17sm2634468wmc.48.2020.05.06.05.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:08:51 -0700 (PDT)
Date:   Wed, 6 May 2020 08:08:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next 2/2] virtio-net: fix the XDP truesize
 calculation for mergeable buffers
Message-ID: <20200506075807-mutt-send-email-mst@kernel.org>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506061633.16327-2-jasowang@redhat.com>
 <20200506033259-mutt-send-email-mst@kernel.org>
 <789fc6e6-9667-a609-c777-a9b1fed72f41@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <789fc6e6-9667-a609-c777-a9b1fed72f41@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 04:21:15PM +0800, Jason Wang wrote:
> 
> On 2020/5/6 下午3:37, Michael S. Tsirkin wrote:
> > On Wed, May 06, 2020 at 02:16:33PM +0800, Jason Wang wrote:
> > > We should not exclude headroom and tailroom when XDP is set. So this
> > > patch fixes this by initializing the truesize from PAGE_SIZE when XDP
> > > is set.
> > > 
> > > Cc: Jesper Dangaard Brouer<brouer@redhat.com>
> > > Signed-off-by: Jason Wang<jasowang@redhat.com>
> > Seems too aggressive, we do not use up the whole page for the size.
> > 
> > 
> > 
> 
> For XDP yes, we do:
> 
> static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
>                       struct ewma_pkt_len *avg_pkt_len,
>                       unsigned int room)
> {
>     const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
>     unsigned int len;
> 
>     if (room)
>         return PAGE_SIZE - room;
> 
> ...
> 
> Thanks

Hmm. But that's only for new buffers. Buffers that were outstanding
before xdp was attached don't use the whole page, do they?




Also, with TCP smallqueues blocking the queue like that might be a problem.
Could you try and check performance impact of this?
I looked at what other drivers do and I see they tend to copy the skb
in XDP_PASS case. ATM we don't normally - but should we?

-- 
MST

