Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40AE2B4B6C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732229AbgKPQid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:38:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732228AbgKPQic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605544711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ffJmvhYXz7whcm++8xwN8hrC5cWfzVBr5ihcuVy03Ac=;
        b=Ju6JQkXri6nxCIdb8DA0FsaktUMwPnvlTYKagy1TFRiXVOrHY/1bF3KidiYv1SJC1Ggnxt
        7PylS+IVewfHp0ZbgUMGfC20a/r6r18DKtWXTVGdMYj1OT0EsNLw8gDGW3GplpefKCW8JC
        EmxJkPf12OwCkZ5GOdSsuOWSrz+QP7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-WcN_lQHEOn2HEOVy7tef_g-1; Mon, 16 Nov 2020 11:38:27 -0500
X-MC-Unique: WcN_lQHEOn2HEOVy7tef_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA38C1005513;
        Mon, 16 Nov 2020 16:38:25 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.193.190])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82DF25B4A2;
        Mon, 16 Nov 2020 16:38:24 +0000 (UTC)
Date:   Mon, 16 Nov 2020 17:38:21 +0100
From:   Antonio Cardace <acardace@redhat.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 3/4] selftests: extract common functions in
 ethtool-common.sh
Message-ID: <20201116163821.njb4ldycup2ywcpq@yoda.fritz.box>
References: <20201113231655.139948-1-acardace@redhat.com>
 <20201113231655.139948-3-acardace@redhat.com>
 <20201116161702.wznoj6z4ceujkydj@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116161702.wznoj6z4ceujkydj@lion.mk-sys.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 05:17:02PM +0100, Michal Kubecek wrote:
> On Sat, Nov 14, 2020 at 12:16:54AM +0100, Antonio Cardace wrote:
> > Factor out some useful functions so that they can be reused
> > by other ethtool-netdevsim scripts.
> > 
> > Signed-off-by: Antonio Cardace <acardace@redhat.com>
> 
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> 
> Just one comment:
> 
> [...]
> > +function get_netdev_name {
> > +    local -n old=$1
> > +
> > +    new=$(ls /sys/class/net)
> > +
> > +    for netdev in $new; do
> > +	for check in $old; do
> > +            [ $netdev == $check ] && break
> > +	done
> > +
> > +	if [ $netdev != $check ]; then
> > +	    echo $netdev
> > +	    break
> > +	fi
> > +    done
> > +}
> [...]
> > +function make_netdev {
> > +    # Make a netdevsim
> > +    old_netdevs=$(ls /sys/class/net)
> > +
> > +    if ! $(lsmod | grep -q netdevsim); then
> > +	modprobe netdevsim
> > +    fi
> > +
> > +    echo $NSIM_ID > /sys/bus/netdevsim/new_device
> > +    echo `get_netdev_name old_netdevs`
> > +}
> 
> This would be rather unpredictable if someone ran another selftest (or
> anything else that would create a network device) in parallel. IMHO it
> would be safer (and easier) to get the name of the new device from
> 
>   /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/
> 
> But as this is not new code and you are just moving existing code, it
> can be done in a separate patch.

Yes it does make sense, I can send a patch for this once this is merged.

Thanks for the review.

Antonio

