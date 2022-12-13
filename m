Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A1B64B949
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 17:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbiLMQJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 11:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiLMQJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:09:21 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7982C26DB;
        Tue, 13 Dec 2022 08:09:20 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id a9so235864pld.7;
        Tue, 13 Dec 2022 08:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4tFhyWdl5CQaHxKakHlBhtPo8vjJLnu37GaGjpzYKLY=;
        b=MuupRT6NiaoDaeXjN5QATL127R0tKhTu1TE4P+2wLMod31puoEKkRyT9g+l7oFEyxT
         6RY/0hHTBc5pnb13fkPSpkP/PNCzPwZgE297i5Fif0mo3y9FwWaSFt/oNTuMxo3RgW+d
         C/pN1LoNKRhqC7FRvaclEuxEGsk5cDOsEBFbzxkxCbNOvj/Wl83NoBV9DlAo2wQ1AI+2
         Xy7iIqnsmpU+RVnVp42k5gJ3bD4jnabkUm9nnOjtj3r4GtRCrZK0sDLim5y236F403W3
         ma2Phc24WjBxSuLjsmiwNENoXZzzzuRoOuS0WZZkbCnGa1VdRvmnzOs7FXP09gorlJL9
         F96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4tFhyWdl5CQaHxKakHlBhtPo8vjJLnu37GaGjpzYKLY=;
        b=hz4VPde3I1V+DNyDLE1YNHnte23mo8JSd5NpBjOF5BENjXKnUnnXSvnUkObytY43X9
         edSftxe4DktEiiXT/B8LR7Ga1+2FV9OIwxke+5BlBx+V6PG6iBrWxNRnK146uZ5E3LXy
         szpzqhHXKmMaRKLRnS9WKziYdeGL2hFKChjm8V1zeTzSvSXPBf2NYTGTDNcG0tMQQDAD
         MJ8ywYsP0qYleJZEybuJxZp4gWfdsVx6C4U9Z9TUtXuKkeO9gHGSB8Vrg90lCDU0Kfqr
         gCTeZ0020O65kUU7wcy3ngwjaWz67hPMketzXP80g6AkeiBUr46T1gSK0YxP6j2pu8lb
         eCUw==
X-Gm-Message-State: ANoB5pmzLUtC3bfcK5l53UDRtiJ4yrnFVgYgJd61S/9cNBaDGHYiBxN1
        Utt8sZwcseel7904tbqcJq0=
X-Google-Smtp-Source: AA0mqf6XfsBTBfgwkOKZ89PyM+a95m8MvihGTHWxpAjBz/a9DFWDfJ1AFIzpueCySw4Gs2ZJOX7RKw==
X-Received: by 2002:a17:902:d192:b0:189:c19a:2cd9 with SMTP id m18-20020a170902d19200b00189c19a2cd9mr18084608plb.25.1670947759749;
        Tue, 13 Dec 2022 08:09:19 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id x15-20020a170902ec8f00b00189371b5971sm44851plg.220.2022.12.13.08.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 08:09:19 -0800 (PST)
Message-ID: <08bd63d5de4ea8814ddd58c51ca6d1c17d0990e6.camel@gmail.com>
Subject: Re: [PATCH intel-next 4/5] i40e: pull out rx buffer allocation to
 end of i40e_clean_rx_irq()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>, tirtha@gmail.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Date:   Tue, 13 Dec 2022 08:09:15 -0800
In-Reply-To: <20221213105023.196409-5-tirthendu.sarkar@intel.com>
References: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
         <20221213105023.196409-5-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 16:20 +0530, Tirthendu Sarkar wrote:
> Previously i40e_alloc_rx_buffers() was called for every 32 cleaned
> buffers. For multi-buffers this may not be optimal as there may be more
> cleaned buffers in each i40e_clean_rx_irq() call. So this is now pulled
> out of the loop and moved to the end of i40e_clean_rx_irq().
>=20
> As a consequence instead of counting the number of buffers to be cleaned,
> I40E_DESC_UNUSED() can be used to call i40e_alloc_rx_buffers().
>=20
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

I suspect this will lead to performance issues on systems configured
with smaller ring sizes. Specifically with this change you are limiting
things to only allocating every 64 (NAPI_POLL_WEIGHT/budget) packets.

> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/et=
hernet/intel/i40e/i40e_txrx.c
> index e01bcc91a196..dc9dc0acdd37 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2425,7 +2425,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_r=
ing, int budget,
>  			     unsigned int *rx_cleaned)
>  {
>  	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0, frame_sz =3D=
 0;
> -	u16 cleaned_count =3D I40E_DESC_UNUSED(rx_ring);
>  	unsigned int offset =3D rx_ring->rx_offset;
>  	struct sk_buff *skb =3D rx_ring->skb;
>  	u16 ntp =3D rx_ring->next_to_process;
> @@ -2450,13 +2449,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_=
ring, int budget,
>  		unsigned int size;
>  		u64 qword;
> =20
> -		/* return some buffers to hardware, one at a time is too slow */
> -		if (cleaned_count >=3D I40E_RX_BUFFER_WRITE) {
> -			failure =3D failure ||
> -				  i40e_alloc_rx_buffers(rx_ring, cleaned_count);
> -			cleaned_count =3D 0;
> -		}
> -
>  		rx_desc =3D I40E_RX_DESC(rx_ring, ntp);
> =20
>  		/* status_error_len will always be zero for unused descriptors
> @@ -2479,7 +2471,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_r=
ing, int budget,
>  			rx_buffer =3D i40e_rx_bi(rx_ring, ntp);
>  			I40E_INC_NEXT(ntp, ntc, rmax);
>  			i40e_reuse_rx_page(rx_ring, rx_buffer);
> -			cleaned_count++;
>  			continue;
>  		}
> =20
> @@ -2531,7 +2522,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_r=
ing, int budget,
>  		}
> =20
>  		i40e_put_rx_buffer(rx_ring, rx_buffer);
> -		cleaned_count++;
> =20
>  		I40E_INC_NEXT(ntp, ntc, rmax);
>  		if (i40e_is_non_eop(rx_ring, rx_desc))
> @@ -2558,6 +2548,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_r=
ing, int budget,
>  	rx_ring->next_to_process =3D ntp;
>  	rx_ring->next_to_clean =3D ntc;
> =20
> +	failure =3D i40e_alloc_rx_buffers(rx_ring, I40E_DESC_UNUSED(rx_ring));
> +
>  	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
>  	rx_ring->skb =3D skb;

I am not a fan of this "failure" approach either. I hadn't noticed it
before but it is problematic. It would make much more sense to take an
approach similar to what we did for Tx where we kick the ring
periodically if it looks like it is stuck, in this case empty.

The problem is if you have memory allocation issues the last thing you
probably need is a NIC deciding to become memory hungry itself and
sticking in an allocation loop.
