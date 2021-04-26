Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546F236B472
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 16:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhDZOC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 10:02:59 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21366 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhDZOC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 10:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1619445723; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=UGOk35mQQbE2f7UY1W3lZfCBuIr072oCYc/IG5TqfkW4dw/WQvrfLNfMswH5UZmK5QPRRjiDCrPEMkxLCnROWI10blqW9MtmCuqAQNyO/rsUxtJ3U2HtLK1iLy8vR71kLiXAu0tWY5p0wMtXkMHhXf1ZKiRh4atQSUcSXtsr1Fg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1619445723; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=rzsZ83jDBREjyjIqQHOvAx9cUe0wGukCjDAduzsjysY=; 
        b=WDEDgpuwC8Dguh1O8y95T4TQB2sD6kAWDbd33kqEJR1XhVa7i7oyXtepLGXzCidFneOnrWJpKdH622LymDlGkAme/is5od+lY2yN31DTodjx4XFM/VIv3TNIsbZMiZDoylvp/gto88vF34QjVbcPcI7laOfC6IpNsOu23kEMwr0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com> header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1619445723;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=rzsZ83jDBREjyjIqQHOvAx9cUe0wGukCjDAduzsjysY=;
        b=jeK3yROBJkjiR2Ml4jEB8wPmQRugSoQqGg5/p6IZWle0F/gsF+1w1VuAcQwZSlIL
        VE9syP7do0DOSWeBuA8hNUYIn0ZlLD1hznje6t68LulQYS810duCdKlpsArrXSmWSwQ
        A1e/1rciwcvJA62tS8bHCcpJDbt0bgzxi+pRPTx0=
Received: from anirudhrb.com (49.207.208.26 [49.207.208.26]) by mx.zohomail.com
        with SMTPS id 1619445705390287.8470601189231; Mon, 26 Apr 2021 07:01:45 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:31:38 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Leonardo Antoniazzi <leoanto@aruba.it>, mail@anirudhrb.com
Subject: Re: [PATCH] net: hso: fix NULL-deref on disconnect regression
Message-ID: <YIbHwqG6eukP9uQg@anirudhrb.com>
References: <20210426081149.10498-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426081149.10498-1-johan@kernel.org>
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 10:11:49AM +0200, Johan Hovold wrote:
> Commit 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device
> unregistration") fixed the racy minor allocation reported by syzbot, but
> introduced an unconditional NULL-pointer dereference on every disconnect
> instead.
> 
> Specifically, the serial device table must no longer be accessed after
> the minor has been released by hso_serial_tty_unregister().
> 
> Fixes: 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device unregistration")
> Cc: stable@vger.kernel.org
> Cc: Anirudh Rayabharam <mail@anirudhrb.com>
> Reported-by: Leonardo Antoniazzi <leoanto@aruba.it>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/net/usb/hso.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 9bc58e64b5b7..3ef4b2841402 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -3104,7 +3104,7 @@ static void hso_free_interface(struct usb_interface *interface)
>  			cancel_work_sync(&serial_table[i]->async_put_intf);
>  			cancel_work_sync(&serial_table[i]->async_get_intf);
>  			hso_serial_tty_unregister(serial);
> -			kref_put(&serial_table[i]->ref, hso_serial_ref_free);
> +			kref_put(&serial->parent->ref, hso_serial_ref_free);
>  		}
>  	}

Ah, my bad. Thanks Johan for the fix!

Reviewed-by: Anirudh Rayabharam <mail@anirudhrb.com>

	- Anirudh.
