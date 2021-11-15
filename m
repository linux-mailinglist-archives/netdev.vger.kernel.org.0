Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD045071D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbhKOOgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:36:52 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:55782 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbhKOOfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:35:42 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 411BC2190B;
        Mon, 15 Nov 2021 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636986757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/BmFWPUbMUO9SaokmWWDreQ/zmCH+4LsF56XkouMeno=;
        b=xydqXcHDqzrG0u+JrXFUUjGgjh+1DY50vRsjKbMOds0NkqP191EeDFsumg2aK8hvY+YzE8
        srQcXj1KzB2HU6h6FzsM1w4OH7I0F3kVaWe1g14qsR7LznP6c8Una4sC+nRxZrke6RmOx+
        Pip+vylKaHs9uLGHP3QvSzKL3OlAix4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636986757;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/BmFWPUbMUO9SaokmWWDreQ/zmCH+4LsF56XkouMeno=;
        b=pyUgTE63MjcSpkknBDsVcd1exbk55xq/AFE203tesHNR3S4xsRkz39QXYlyVXmhuJVvfLi
        Juxc/aD7ysTFHkDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A36B913D86;
        Mon, 15 Nov 2021 14:32:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rrsoJIRvkmGxKQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Mon, 15 Nov 2021 14:32:36 +0000
Subject: Re: [PATCH v0] NFC: reorganize the functions in nci_request
To:     Lin Ma <linma@zju.edu.cn>, netdev@vger.kernel.org
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, jirislaby@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <20211115142938.8109-1-linma@zju.edu.cn>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <84cf637f-4cda-a7ad-a5d1-484254ef16a5@suse.de>
Date:   Mon, 15 Nov 2021 17:32:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115142938.8109-1-linma@zju.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/15/21 5:29 PM, Lin Ma пишет:
> There is a possible data race as shown below:
> 
> thread-A in nci_request()       | thread-B in nci_close_device()
>                                  | mutex_lock(&ndev->req_lock);
> test_bit(NCI_UP, &ndev->flags); |
> ...                             | test_and_clear_bit(NCI_UP, &ndev->flags)
> mutex_lock(&ndev->req_lock);    |
>                                  |
> 
> This race will allow __nci_request() to be awaked while the device is
> getting removed.
> 
> Similar to commit e2cb6b891ad2 ("bluetooth: eliminate the potential race
> condition when removing the HCI controller"). this patch alters the
> function sequence in nci_request() to prevent the data races between the
> nci_close_device().
Please add Fixes tag
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---
>   net/nfc/nci/core.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index 6fd873aa86be..2ab2d6a1a143 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -144,12 +144,15 @@ inline int nci_request(struct nci_dev *ndev,
>   {
>   	int rc;
>   
> -	if (!test_bit(NCI_UP, &ndev->flags))
> -		return -ENETDOWN;
> -
>   	/* Serialize all requests */
>   	mutex_lock(&ndev->req_lock);
> -	rc = __nci_request(ndev, req, opt, timeout);
> +	/* check the state after obtaing the lock against any races
> +	 * from nci_close_device when the device gets removed.
> +	 */
> +	if (test_bit(NCI_UP, &ndev->flags))
> +		rc = __nci_request(ndev, req, opt, timeout);
> +	else
> +		rc = -ENETDOWN;
>   	mutex_unlock(&ndev->req_lock);
>   
>   	return rc;
> 
