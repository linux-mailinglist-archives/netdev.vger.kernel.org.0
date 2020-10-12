Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E4328AF8E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgJLIBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:01:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbgJLIBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602489677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f3yX0WlF+2eHtbcZPvQACZAma8VUwa9B1j/FjYNY+fs=;
        b=VRo+3GyvC/eR7YloHphLuAgh/dWPWiHYZhu8B4MpWYKxgFc7H9LUXxP3eYOrryckXJiKtF
        8BXL/wCPjtE1u72cPPQYyZ31psJxVoLhV/AjNL1/ki8spInYXZm2sxSZbauXgm4iDXUr4B
        +r5U/uoryxWuK2vwd8myh4HYH/yt+ZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-eFcuIaVLMxmj3lvAneKo6w-1; Mon, 12 Oct 2020 04:01:13 -0400
X-MC-Unique: eFcuIaVLMxmj3lvAneKo6w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64E3B64085;
        Mon, 12 Oct 2020 08:01:12 +0000 (UTC)
Received: from ovpn-113-160.ams2.redhat.com (ovpn-113-160.ams2.redhat.com [10.36.113.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AC615578F;
        Mon, 12 Oct 2020 08:01:10 +0000 (UTC)
Message-ID: <c5ea3f4a906c0dcd7b53b0dd70fc13eb3d2386e2.camel@redhat.com>
Subject: Re: [PATCH net 0/2] mptcp: some fallback fixes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org
Date:   Mon, 12 Oct 2020 10:01:10 +0200
In-Reply-To: <20201010111332.3ac29a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1602262630.git.pabeni@redhat.com>
         <20201010111332.3ac29a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-10-10 at 11:13 -0700, Jakub Kicinski wrote:
> On Fri,  9 Oct 2020 18:59:59 +0200 Paolo Abeni wrote:
> > pktdrill pointed-out we currently don't handle properly some
> > fallback scenario for MP_JOIN subflows
> > 
> > The first patch addresses such issue.
> > 
> > Patch 2/2 fixes a related pre-existing issue that is more
> > evident after 1/2: we could keep using for MPTCP signaling
> > closed subflows.
> 
> Applied, thanks Paolo.
> 
> You already have a few of those in the code, but:
> 
> +	if (... &&
> +	    schedule_work(&mptcp_sk(sk)->work))
> +		sock_hold(sk);
> 
> isn't this a fairly questionable construct?
> 
> You take a reference for the async work to release _after_ you
> scheduled the async work? 

Thank you for reviewing! Indeed we need to add some comments there:
IIRC that chunk already raised a question in the past.

Afaics, that is safe because the caller (a subflow) held a reference to
sk and sk can't be freed in between the scheduling and the next
sock_hold(). 

We have a pending refactor, targeting the next development cycle, that
will consolidate the workqueue scheduling into an helper. We will add
some comments there to clarify the above.

Thanks,

Paolo

