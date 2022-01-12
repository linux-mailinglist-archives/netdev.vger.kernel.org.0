Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEC148C9BF
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343738AbiALRex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:34:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39236 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355762AbiALRed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:34:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C035B82010;
        Wed, 12 Jan 2022 17:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EEEC36AE5;
        Wed, 12 Jan 2022 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642008870;
        bh=g+h2nhy7FCYinfQF3fyEFVqJj7Hzj5eS5dA6+TP8D7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VFJHjUayAInkThh3PMj77cOAt9WWN/Qiy2m9lU/lPwfheROnHgOSsA5X9e88lVdAW
         /dj1bv8CMIEPqtOJgQ4qq7/xI8hJUqRb1IywfNEwYlJmtVK1py1yWVz9j/OKX4duXO
         nsmbTVB+XqnQzTt228ep0vaqDc3xRZCVI5FaAVcLuc8yF2DWkNVdlI16reUvuE46Rm
         CNKK8lL1YxNy3LXdbavW1vxDu1Xs13vc7L+PCqbHhZbXRqVIpAV/h6siRW/PH+BZlY
         gWuzsN9X1BKUGgjWDd0zVTib5HowlV7JUq4aQaLoNnNq3JPSAm5yfuU8F+8fSDbZXq
         kVYijJXby02Ew==
Date:   Wed, 12 Jan 2022 09:34:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     davem@davemloft.net, krzysztof.kozlowski@canonical.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        wengjianfeng@yulong.com
Subject: Re: [PATCH v3] nfc: st-nci: Fix potential buffer overflows in
 EVT_TRANSACTION
Message-ID: <20220112093428.58981696@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111164543.3233040-1-jordy@pwning.systems>
References: <20211117171554.2731340-1-jordy@pwning.systems>
        <20220111164543.3233040-1-jordy@pwning.systems>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 17:45:43 +0100 Jordy Zomer wrote:
> It appears that there are some buffer overflows in EVT_TRANSACTION.
> This happens because the length parameters that are passed to memcpy
> come directly from skb->data and are not guarded in any way.
> 
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>

This patch with more context:

> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> index 7764b1a4c3cf..cdb59ddff4e8 100644
> --- a/drivers/nfc/st-nci/se.c
> +++ b/drivers/nfc/st-nci/se.c
> @@ -333,18 +333,28 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
>                 transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);

What checks skb->len > 2 ?

>                 if (!transaction)
>                         return -ENOMEM;

Leaks skb ?

>                 transaction->aid_len = skb->data[1];
> +
> +               /* Checking if the length of the AID is valid */
> +               if (transaction->aid_len > sizeof(transaction->aid))
> +                       return -EINVAL;
> 
>                 memcpy(transaction->aid, &skb->data[2], transaction->aid_len);

What checks skb->len > 2 + transaction->aid_len ?

>                 /* Check next byte is PARAMETERS tag (82) */
>                 if (skb->data[transaction->aid_len + 2] !=

.. make that skb->len > 2 + transaction->aid_len + 1

>                     NFC_EVT_TRANSACTION_PARAMS_TAG)
>                         return -EPROTO;

Leaks skb ? (btw devm_kmalloc() in message processing could probably as well be counted 
as leak unless something guarantees attacker can't generate infinite messages of this type)

>                 transaction->params_len = skb->data[transaction->aid_len + 3];

.. skb->len > 2 + transaction->aid_len + 1 + 1

> +               /* Total size is allocated (skb->len - 2) minus fixed array members */
> +               if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))

So this check makes sure we don't overflow transaction->params, right?
Again, does skb->len not have to be validated as well?

> +                       return -EINVAL;
> +
>                 memcpy(transaction->params, skb->data +
>                        transaction->aid_len + 4, transaction->params_len);
>  
>                 r = nfc_se_transaction(ndev->nfc_dev, host, transaction);
>                 break;
