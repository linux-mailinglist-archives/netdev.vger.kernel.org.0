Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E652D18ED65
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 00:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgCVX6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 19:58:11 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40826 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgCVX6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 19:58:11 -0400
Received: by mail-ed1-f68.google.com with SMTP id w26so7994335edu.7;
        Sun, 22 Mar 2020 16:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=16n5W71pgyT6GLbXOW01rJLBzPo7sl4nqjxN9D4dB2g=;
        b=MUWX8hEIe2xtcWw5PGoYP41lapbLjFNAQ5MwKfKtOqvT8ALEsxnOJtpJkwHDCApYIR
         yIi0d7E0FFRCNJ70LAd49zcszL/tVjZkPP8HZSAwkD8sUzIUxsZGdvzh8PPocI/ihEC4
         eDDudVlNJEJJTt9wWsez6yE2BM7W7ASQctkuhBTqAqhcdrWiUmfm0fPM5GlsMwjwh4Vp
         GCMKtMPAS6y7qGZaqqS3QWOpBnW3XmVqdgNc6lPV6M2dRjg1i+cwNpFfW/wbbl0FRFfq
         DkddZhhAzx6nWtdKVlBnKYIB3bIo9Rx2bfE6D7dTTQQXR4HT9WY5+1CNjS/t20LCvnkz
         ovlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=16n5W71pgyT6GLbXOW01rJLBzPo7sl4nqjxN9D4dB2g=;
        b=Vbq3Npqr/AbOlZJ7tteEUxrFJ2UUtxNN37nTKDzC6pqsMaqWWgCViiovJeEP7F8PQs
         qE+Do62ZlXDPiqr/dHWseFRW8RwvDC1HrM6JhTxEhxv4aMINJQSxXCtJG+FH3nYpbDGr
         pke7wXncPmAIqjZBIkraNrnNl4VtKCY4f7dYHxdVZPq72MZOFm8Kl3xBf99gPeqQAM8I
         bdK7t7Rco/1gcETyyNXIgkbB7FRvYm9LlbWXX1gMR4TJ9WtFPRw01DZ6lB1Jj9YQkpgq
         Z+pKo/8WlVTA378iMyqERGilFeXmDCA1C3nguMMgb7uIkWfuaFgu7AHjuFpXrd8r6J4Q
         Mf0A==
X-Gm-Message-State: ANhLgQ2uGNOYP+3Wibr9dON5SQRBq3ptKA82N1w3KCXIujye6mRv9UY6
        peztLYJq9ah5DTCayAv6dtizNav3alhn9rxHRLc=
X-Google-Smtp-Source: ADFU+vszdzmENHtwsaq4alTfUpwKBMZhf2fMVh/X2IJgdcPXWfW4LIPeYm2Ir/FxfjTfYe4DrU3ivo+G8vBz95Jx+0I=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr19159147edc.368.1584921488688;
 Sun, 22 Mar 2020 16:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200322210957.3940-1-f.fainelli@gmail.com>
In-Reply-To: <20200322210957.3940-1-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 23 Mar 2020 01:57:57 +0200
Message-ID: <CA+h21ho5tVuRSOfFXLDdexNcqz3BtH0st0zwrhJBR-hb4rZKkg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Implement flow dissection for tag_brcm.c
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Mar 2020 at 23:10, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Provide a flow_dissect callback which returns the network offset and
> where to find the skb protocol, given the tags structure a common
> function works for both tagging formats that are supported.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Looks good to me.

>  net/dsa/tag_brcm.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index 9c3114179690..0d3f796d14a3 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -142,6 +142,27 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>
>         return skb;
>  }
> +
> +static int brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
> +                                int *offset)
> +{
> +       /* We have been called on the DSA master network device after
> +        * eth_type_trans() which pulled the Ethernet header already.
> +        * Frames have one of these two layouts:
> +        * -----------------------------------
> +        * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
> +        * -----------------------------------
> +        * -----------------------------------
> +        * | 4b tag | MAC DA | MAC SA | Type | DSA_TAG_PROTO_BRCM_PREPEND
> +        * -----------------------------------
> +        * skb->data points 2 bytes before the actual Ethernet type field and
> +        * we have an offset of 4bytes between where skb->data and where the
> +        * payload starts.
> +        */
> +       *offset = BRCM_TAG_LEN;
> +       *proto = ((__be16 *)skb->data)[1];
> +       return 0;
> +}
>  #endif
>
>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
> @@ -177,6 +198,7 @@ static const struct dsa_device_ops brcm_netdev_ops = {
>         .xmit   = brcm_tag_xmit,
>         .rcv    = brcm_tag_rcv,
>         .overhead = BRCM_TAG_LEN,
> +       .flow_dissect = brcm_tag_flow_dissect,
>  };
>
>  DSA_TAG_DRIVER(brcm_netdev_ops);
> @@ -205,6 +227,7 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
>         .xmit   = brcm_tag_xmit_prepend,
>         .rcv    = brcm_tag_rcv_prepend,
>         .overhead = BRCM_TAG_LEN,
> +       .flow_dissect = brcm_tag_flow_dissect,
>  };
>
>  DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
> --
> 2.19.1
>

Regards,
-Vladimir
