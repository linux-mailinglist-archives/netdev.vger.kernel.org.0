Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E6247B8F
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 02:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHRAjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 20:39:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726314AbgHRAju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 20:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597711188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6Zt/23/e2PVCilko2df88KdBjhS8HKOQy/EwEXaMdY=;
        b=Si3uSKAVJKMAL7WZ6VOxQyOAj5j7VddY/aqWeGfyieCH9oZw7LPwiQxiKqq+HhtrdSHupt
        9IpWbN149x5k/zA6nCMDG1f8eQoyQGifQ17vu9WNNwEOnVFnYTh79EnGzixKz3ve4uN/zs
        AP0SsT3ATngzwD7KCMaq3Lbfw4h6tIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-rNCtf7k1NN2c_kzqWI6GBQ-1; Mon, 17 Aug 2020 20:39:44 -0400
X-MC-Unique: rNCtf7k1NN2c_kzqWI6GBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CA53185E528;
        Tue, 18 Aug 2020 00:39:43 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2355D5C3E0;
        Tue, 18 Aug 2020 00:39:39 +0000 (UTC)
Date:   Tue, 18 Aug 2020 02:39:35 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 nf] selftests: netfilter: exit on invalid parameters
Message-ID: <20200818023935.3bee52fc@elisabeth>
In-Reply-To: <20200814185544.8732-1-fabf@skynet.be>
References: <20200814185544.8732-1-fabf@skynet.be>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabian,

On Fri, 14 Aug 2020 20:55:44 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> exit script with comments when parameters are wrong during address
> addition. No need for a message when trying to change MTU with lower
> values: output is self-explanatory
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  tools/testing/selftests/netfilter/nft_flowtable.sh | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
> index 28e32fddf9b2c..c3617d0037f2e 100755
> --- a/tools/testing/selftests/netfilter/nft_flowtable.sh
> +++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
> @@ -97,9 +97,17 @@ do
>  done
>  
>  ip -net nsr1 link set veth0 mtu $omtu
> +if [ $? -ne 0 ]; then
> +	exit 1
> +fi
> +

As some of your recent patches are also clean-ups, perhaps you get some
assistance from 'shellcheck' (https://www.shellcheck.net/). For
example, this could be written as:

  ip -net nsr1 link set veth0 mtu $omtu || exit 1

or, I'm not sure it's doable, you could get all those checks for free
by setting the -e flag for the entire script. You would then need to
take care explicitly of commands that can legitimately fail.

-- 
Stefano

