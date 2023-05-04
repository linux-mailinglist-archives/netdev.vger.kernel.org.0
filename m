Return-Path: <netdev+bounces-277-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C665E6F6AE9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:11:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 087F61C210FA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93B8FC0C;
	Thu,  4 May 2023 12:11:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE83EFBE1
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:11:08 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F2E5BB1;
	Thu,  4 May 2023 05:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/QXPslg/3qx/2kW3J+zsuUr+vnPh+T8eN64JH56Qscg=;
	t=1683202267; x=1684411867; b=PSFxoIfXUypASoldpClIM2t1TlpzRktBgjpIIg11neYYz0B
	3y9o2fuEXT1DrHP0c1YtOkHAQJIlFQpee49rYysVjyqkFJQCwOf07r4+1dWJi/jjWLWibCLeaOhfq
	sEa5llk6XUfVznhLm1jHGpTtiXfRTQVTEnazM8x/2zCG2aCU33qh/nNCqXr1JdKTdJvYadvKOJ8UE
	IxAaeIfORRak0d5tsYutAEysusScHs9tyTPDh7YdKpjCJrvpFoymbYSACccnT56/b1ZG+mDIndcBz
	WOxuSpu0gylFbfTv9ohV5BLSfDMDyP+9sZqlmaPL6qqNWQwb/3gwrUYIW7RgRpkw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1puXnQ-00GwbM-06;
	Thu, 04 May 2023 14:10:52 +0200
Message-ID: <8d2b0aec270b8cd0111654dc4b361987a112d3ce.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: iwlwifi: Fix spurious packet drops with RSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: "Greenman, Gregory" <gregory.greenman@intel.com>, Kalle Valo
 <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, "Goodstein, Mordechay"
 <mordechay.goodstein@intel.com>,  "Coelho, Luciano"
 <luciano.coelho@intel.com>, "Sisodiya, Mukesh" <mukesh.sisodiya@intel.com>,
  "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 04 May 2023 14:10:50 +0200
In-Reply-To: <20230430001348.3552-1-sultan@kerneltoast.com>
References: <20230430001348.3552-1-sultan@kerneltoast.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[let's see if my reply will make it to the list, the original seems to
not have]

On Sun, 2023-04-30 at 00:13 +0000, Sultan Alsawaf wrote:
> From: Sultan Alsawaf <sultan@kerneltoast.com>
>=20
> When RSS is used and one of the RX queues lags behind others by more than
> 2048 frames, then new frames arriving on the lagged RX queue are
> incorrectly treated as old rather than new by the reorder buffer, and are
> thus spuriously dropped. This is because the reorder buffer treats frames
> as old when they have an SN that is more than 2048 away from the head SN,
> which causes the reorder buffer to drop frames that are actually valid.
>=20
> The odds of this occurring naturally increase with the number of
> RX queues used, so CPUs with many threads are more susceptible to
> encountering spurious packet drops caused by this issue.
>=20
> As it turns out, the firmware already detects when a frame is either old =
or
> duplicated and exports this information, but it's currently unused. Using
> these firmware bits to decide when frames are old or duplicated fixes the
> spurious drops.

So I assume you tested it now, and it works? Somehow I had been under
the impression we never got it to work back when...

> Johannes mentions that the 9000 series' firmware doesn't support these
> bits, so disable RSS on the 9000 series chipsets since they lack a
> mechanism to properly detect old and duplicated frames.

Indeed, I checked this again, I also somehow thought it was backported
to some versions but doesn't look like. We can either leave those old
ones broken (they only shipped with fewer cores anyway), or just disable
it as you did here, not sure. RSS is probably not as relevant with those
slower speeds anyway.

> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> @@ -918,7 +918,6 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
>         struct iwl_mvm_sta *mvm_sta;
>         struct iwl_mvm_baid_data *baid_data;
>         struct iwl_mvm_reorder_buffer *buffer;
> -       struct sk_buff *tail;
>         u32 reorder =3D le32_to_cpu(desc->reorder_data);
>         bool amsdu =3D desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU;
>         bool last_subframe =3D
> @@ -1020,7 +1019,7 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
>                                  rx_status->device_timestamp, queue);
>=20
>         /* drop any oudated packets */
> -       if (ieee80211_sn_less(sn, buffer->head_sn))
> +       if (reorder & IWL_RX_MPDU_REORDER_BA_OLD_SN)
>                 goto drop;
>=20
>         /* release immediately if allowed by nssn and no stored frames */
> @@ -1068,24 +1067,12 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
>                 return false;
>         }

All that "send queue sync" code in the middle that was _meant_ to fix
this issue but I guess never really did can also be removed, no? And the
timer, etc. etc.

johannes

[leaving full quote for the benefit of the mailing list]

>=20
> -       index =3D sn % buffer->buf_size;
> -
> -       /*
> -        * Check if we already stored this frame
> -        * As AMSDU is either received or not as whole, logic is simple:
> -        * If we have frames in that position in the buffer and the last =
frame
> -        * originated from AMSDU had a different SN then it is a retransm=
ission.
> -        * If it is the same SN then if the subframe index is incrementin=
g it
> -        * is the same AMSDU - otherwise it is a retransmission.
> -        */
> -       tail =3D skb_peek_tail(&entries[index].e.frames);
> -       if (tail && !amsdu)
> -               goto drop;
> -       else if (tail && (sn !=3D buffer->last_amsdu ||
> -                         buffer->last_sub_index >=3D sub_frame_idx))
> +       /* drop any duplicated packets */
> +       if (desc->status & cpu_to_le32(IWL_RX_MPDU_STATUS_DUPLICATE))
>                 goto drop;
>=20
>         /* put in reorder buffer */
> +       index =3D sn % buffer->buf_size;
>         __skb_queue_tail(&entries[index].e.frames, skb);
>         buffer->num_stored++;
>         entries[index].e.reorder_time =3D jiffies;
> --
> 2.40.1
>=20


