Return-Path: <netdev+bounces-6892-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C57718965
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3688281591
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF5314284;
	Wed, 31 May 2023 18:31:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB5F3C097
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:31:09 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77618198;
	Wed, 31 May 2023 11:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cFO0KTo2++Ng2RRXlpAW5yD45ZEX1X3u5XV/hZd9TdU=; b=c4AJJM/Id+jv4X4K73t+VCQuYj
	kQSg+zL8IMjg3dZ6L4TYvmWocLbG0FZoOu0L8QLgjzqDPja0iWanYrGvZgemVRbQiBuXUw9nzYHQ+
	HxA8ca7Z7d9pNnV5R+d19ZKa/HHIBMcuoeqIggGdLUZCpX8ereis1zz3siTJ7kWl1I1kIGXQH7jaV
	Tzkg9DVN+682ydWvlFBqTGfXGo53u876a8M234X8XM0kJqvcakeMa3aZdh0en5p/TWSIVTUa8M7OV
	kpoRkuWAOE9a64f1nmWq6mIkBZHAI5V0wWigLWzZdcAx6QtkqzRYOYDI36LOt90Nhb1GYx7B749rR
	CxYZA6uA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1q4Qay-007Vrh-CT; Wed, 31 May 2023 18:30:52 +0000
Date: Wed, 31 May 2023 19:30:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/6] net: Block MSG_SENDPAGE_* from being
 passed to sendmsg() by userspace
Message-ID: <ZHeSXFdWuFjH+vVw@casper.infradead.org>
References: <ZHd9vCcBNtjkqeqg@corigine.com>
 <20230531124528.699123-1-dhowells@redhat.com>
 <20230531124528.699123-3-dhowells@redhat.com>
 <724855.1685556072@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <724855.1685556072@warthog.procyon.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 07:01:12PM +0100, David Howells wrote:
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > > sendpage is removed as a whole slew of pages will be passed in in one go by
> > 
> > on the off-chance that you need to respin for some other reason:
> > 
> > 	s/in in/in/
> 
> What I wrote is correct - there should be two ins.  I could write it as:
> 
> 	... passed in [as an argument] in one go...
> 
> For your amusement, consider:
> 
> 	All the faith he had had had had no effect on the outcome of his life.
> 
> 	https://ell.stackexchange.com/questions/285066/explanation-for-had-had-had-had-being-grammatically-correct

Let's not buffalo Buffalo buffalo ...

