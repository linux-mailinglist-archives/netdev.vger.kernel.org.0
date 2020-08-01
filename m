Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4C32352CA
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 16:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgHAOkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 10:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgHAOkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 10:40:33 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F83C061757
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 07:40:33 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id j187so31465562qke.11
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 07:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mRmB4+8PRxBevydZGBnRlc3z9/QvoJxis+WEAA2l688=;
        b=Sle3mw/0UURgSSq5deGhktvSJ9UQXTd9fDmY2doUhJQ3xiPm3nxmtC8U/ayxaSKVwd
         6XH1TNg4uHvRdKlCr3i2GfW4yFjDZCIpGm9rOZwquuIGRMoN4u30hBUXPvrXHrv4d1fp
         vCsYQuv/8VodNDTU/+zdMznVROHKV3h5mkrrBDQ3urmyAhroscFDZBOvL2QGLeJkvLK3
         hGTqu853GgkLnhg1d9PK9ilpO8AIWQOlyr7cxGQQtBtXGhTO8im8YCn6G4zD6+nndoBo
         LuaBGqzqxKZ122RDlCvtk7MhPLRMTqS0ZBWTXQ7y/iodvvBmD/ehmrLLck+DGX55MV3l
         jyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mRmB4+8PRxBevydZGBnRlc3z9/QvoJxis+WEAA2l688=;
        b=iafgS0zuD/zCUaDuY9JP8NcfjisRBnEabpOiaMkLSThJ2IN61Xka7ac51yQ6LVLQQY
         QBR7nNsOgn1Pllh8SuamzTWrE+1gqlB6/HCfHion02ZdptVQK4vs0xDfUGudTpVVAzLe
         zg7BZMo1+ZPQUjVxCxVONLddVlhVkW50hUPJ6DD0gttvzvis5cRBx7xc2sy3oJZ302Bk
         5Ckp52Bj8t5utKPV2dz3XDbweSf2l2uwf3ep1Sff0Cq6w59VZk7AXrZHhYNX2qv0oYaI
         b+dBkov5a5BUtoX5Vj61IsnTklP/i/iNLGaM/HbRXdFYbT/a9EwaLfiYKXg1FG7oEbE0
         g5dQ==
X-Gm-Message-State: AOAM531nGaDL37oOcTcdkCUkFoZyMKaAYzytnSmiEj9A3BuN+8W+8HzT
        nqKC2U16oEEtDcV2cGVV0XIF6Q==
X-Google-Smtp-Source: ABdhPJzbwskN0/DtlHJAnLQ+QGQOrP7nWCPTapxvskUZYyaFE6IclN+YtQFx90fJdJW1BNlHHFUELw==
X-Received: by 2002:a05:620a:150f:: with SMTP id i15mr8871793qkk.152.1596292832181;
        Sat, 01 Aug 2020 07:40:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id f53sm14352016qta.84.2020.08.01.07.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 07:40:31 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1k1sgY-002RlQ-Ap; Sat, 01 Aug 2020 11:40:30 -0300
Date:   Sat, 1 Aug 2020 11:40:30 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200801144030.GM24045@ziepe.ca>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200731182712.GI24045@ziepe.ca>
 <20200801080026.GJ5493@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801080026.GJ5493@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 11:00:26AM +0300, Dan Carpenter wrote:
> > Without an actual example where this doesn't work right it is hard to
> > say anything more..
> 
> Here is the example that set off the recent patches:
> 
> https://lkml.org/lkml/2020/7/27/199

Oh, that is something completely different. This thread was talking
about '= {}'.

From a C11 perspective the above link is complete initialization of an
aggregate and does not trigger the rule requiring that padding be
zero'd.

C11 only zeros padding during *partial* initialization of an aggregate.

ie this does not zero padding:

void test(void)
{
        extern void copy(const void *ptr, size_t len);
	struct rds_rdma_notify {
		unsigned long user_token;
		unsigned char status __attribute__((aligned(32)));
	} foo = {1, 1};

	// Padding NOT zeroed
	copy(&foo, sizeof(foo));
}

While the addition of a xxx member to make it partial initialization
does zero:

void test(void)
{
        extern void copy(const void *ptr, size_t len);
	struct rds_rdma_notify {
		unsigned long user_token;
		unsigned char status __attribute__((aligned(32)));
		unsigned long xx;
	} foo = {1, 1};

	// Padding NOT zeroed
	copy(&foo, sizeof(foo));
}

(and godbolt confirms this on a wide range of compilers)

> The rest of these patches were based on static analysis from Smatch.
> They're all "theoretical" bugs based on the C standard but it's
> impossible to know if and when they'll turn into real life bugs.

Any patches replaing '= {}' (and usually '= {0}') with memset are not
fixing anything.

The C11 standard requires zeroing padding in these case. It is just
useless churn and in some cases results in worse codegen.

smatch should only warn about this if the aggregate initialization is
not partial.

Jason
