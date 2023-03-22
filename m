Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FED46C4B7F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjCVNTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjCVNTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:19:00 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40145FE9B
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:18:41 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3e0965f70ecso67761cf.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/e20Mt3eJBtDn4whlWHuUSFxZLO9WQUi9MdevR4Kf8=;
        b=TWlF/tdSqN/8acdYnoUMPCVX1vwSJudd9RfephQ08ug2fn9WMWrXswVx5oBuGnO+V2
         I86ZcmrdhfQD4sVFt1xwMmyOKnB/Yz1FPS5ApP5hPlpKiIOk8etYu9JAXB/PHboaSTux
         oWCrWnpePWQtd+NHKySr9M1WIzGInLejaV3J6wYAYtDY2FEAyw3RI7+f2Y2UHX0RO4qf
         RP+S0QChmT8jf+06BEFiuBLmRofPQGxY+G1BkonZGyEe8cdlSMW6eX3E2D0Lkd+r/o0y
         MBgoxflkO6mhJV061VKRtWrgi9w2funKV78ByWRTTFVjsdXuWG9cRQhJ5/JHqbJJq7ar
         UyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/e20Mt3eJBtDn4whlWHuUSFxZLO9WQUi9MdevR4Kf8=;
        b=PHaGkOZugSr5AKUCjVSs/HH+N8+ygGjZFx20n0z7SQO3hFdHwOLeCSiBCJpKzIUj6v
         PDCrpyNJ47fiW7YE1dvyFpWjhkYa1M0qWPRBoErFTkgV8JKNnjjiLPo1w53uQavWvNib
         CKwYXJoaUtKXYLNlWv4n+NNkPJLEC3wD8Dvv8g1/IisX8tg/v/wkKDHL/qAYUD5HOEJ3
         GZ6vGyLmxaBYRAe0cVxSrfOJ4mmHr1wFEHLD5Nu9dyYWIsSuhVyNm5TkZ7EFwZ7bPIMR
         OTzFAvkWY2rLXXuA6nJqkP/8U01JRndZRAZKLVDgN+ChwjqSxZ4RLQl9S27Ua+e3Sw+X
         VdnQ==
X-Gm-Message-State: AO0yUKUJqixDpgQsA8t490zMIwuV8cwTLUZ9CfYQMzHvWvMnbwTF7L6Y
        utOpj2mI0bBKSKBh9hAQYzCkxi/Nw4NP/b/FlLpyDg==
X-Google-Smtp-Source: AK7set9lxWM/lEjUSHvch37Bwr/atH1InK3RQ3R/4oeGLej6EUxPOkY4XiFIeIlMmIpvwfjQOAYaIVvaJAPUvttKLE4=
X-Received: by 2002:a05:622a:551:b0:3e2:3de:371f with SMTP id
 m17-20020a05622a055100b003e203de371fmr333173qtx.15.1679491120767; Wed, 22 Mar
 2023 06:18:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com> <20230313075326.3594869-4-jaewan@google.com>
 <ZA93nupR04173j+h@localhost.localdomain>
In-Reply-To: <ZA93nupR04173j+h@localhost.localdomain>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 22 Mar 2023 22:18:28 +0900
Message-ID: <CABZjns4X-8d6BuE_Mq+t6s3hyUVODyo7rYpyRw_x7j7d+tMgWQ@mail.gmail.com>
Subject: Re: [PATCH v9 3/5] mac80211_hwsim: add PMSR request support via virtio
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 4:21=E2=80=AFAM Michal Kubiak <michal.kubiak@intel.=
com> wrote:
>
> On Mon, Mar 13, 2023 at 07:53:24AM +0000, Jaewan Kim wrote:
> > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or fligh=
t
> > time measurement) is the one and only measurement. FTM is measured by
> > RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> >
> > Add necessary functionalities for mac80211_hwsim to start PMSR request =
by
> > passthrough the request to wmediumd via virtio. mac80211_hwsim can't
> > measure RTT for real because mac80211_hwsim the software simulator and
> > packets are sent almost immediately for real. This change expect wmediu=
md
> > to have all the location information of devices, so passthrough request=
s
> > to wmediumd.
> >
> > In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> > mac80211_hwsim receives the PMSR start request via
> > ieee80211_ops.start_pmsr, the received cfg80211_pmsr_request is resent =
to
> > the wmediumd with command HWSIM_CMD_START_PMSR and attribute
> > HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> > nl80211_pmsr_start() expects.
> >
> > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > ---
> > V7 -> V8: Exported nl80211_send_chandef directly instead of creating
> >           wrapper.
> > V7: Initial commit (split from previously large patch)
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c | 207 +++++++++++++++++++++++++-
> >  drivers/net/wireless/mac80211_hwsim.h |   6 +
> >  2 files changed, 212 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
> > index 65868f28a00f..a692d9c95566 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
> >
> >       /* only used when pmsr capability is supplied */
> >       struct cfg80211_pmsr_capabilities pmsr_capa;
> > +     struct cfg80211_pmsr_request *pmsr_request;
> > +     struct wireless_dev *pmsr_request_wdev;
> >
> >       struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_L=
INKS];
> >  };
> > @@ -3139,6 +3141,208 @@ static int mac80211_hwsim_change_sta_links(stru=
ct ieee80211_hw *hw,
> >       return 0;
> >  }
> >
> > +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *m=
sg,
> > +                                                  struct cfg80211_pmsr=
_ftm_request_peer *request)
> > +{
> > +     struct nlattr *ftm;
> > +
> > +     if (!request->requested)
> > +             return -EINVAL;
> > +
> > +     ftm =3D nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> > +     if (!ftm)
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request-=
>preamble))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD, requ=
est->burst_period))
> > +             return -ENOBUFS;
> > +
> > +     if (request->asap && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_=
ASAP))
> > +             return -ENOBUFS;
> > +
> > +     if (request->request_lci && nla_put_flag(msg, NL80211_PMSR_FTM_RE=
Q_ATTR_REQUEST_LCI))
> > +             return -ENOBUFS;
> > +
> > +     if (request->request_civicloc &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC)=
)
> > +             return -ENOBUFS;
> > +
> > +     if (request->trigger_based && nla_put_flag(msg, NL80211_PMSR_FTM_=
REQ_ATTR_TRIGGER_BASED))
> > +             return -ENOBUFS;
> > +
> > +     if (request->non_trigger_based &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED=
))
> > +             return -ENOBUFS;
> > +
> > +     if (request->lmr_feedback && nla_put_flag(msg, NL80211_PMSR_FTM_R=
EQ_ATTR_LMR_FEEDBACK))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP, req=
uest->num_bursts_exp))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION, req=
uest->burst_duration))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST, req=
uest->ftms_per_burst))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES, r=
equest->ftmr_retries))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION, req=
uest->burst_duration))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR, request-=
>bss_color))
> > +             return -ENOBUFS;
> > +
> > +     nla_nest_end(msg, ftm);
> > +
> > +     return 0;
> > +}
>
> Lenght of lines in the function above exceeds 80 characters.
>
> > +
> > +static int mac80211_hwsim_send_pmsr_request_peer(struct sk_buff *msg,
> > +                                              struct cfg80211_pmsr_req=
uest_peer *request)
> > +{
> > +     struct nlattr *peer, *chandef, *req, *data;
> > +     int err;
> > +
> > +     peer =3D nla_nest_start(msg, NL80211_PMSR_ATTR_PEERS);
> > +     if (!peer)
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put(msg, NL80211_PMSR_PEER_ATTR_ADDR, ETH_ALEN,
> > +                 request->addr))
> > +             return -ENOBUFS;
> > +
> > +     chandef =3D nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_CHAN);
> > +     if (!chandef)
> > +             return -ENOBUFS;
> > +
> > +     err =3D nl80211_send_chandef(msg, &request->chandef);
> > +     if (err)
> > +             return err;
> > +
> > +     nla_nest_end(msg, chandef);
> > +
> > +     req =3D nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_REQ);
>
> Don't you need to check "if (!req)" as you have done for other pointers
> returned by "nla_put_flag()"?
> Is it by mistake or intentional?

My mistake. Thank you for the review.

>
> > +     if (request->report_ap_tsf && nla_put_flag(msg, NL80211_PMSR_REQ_=
ATTR_GET_AP_TSF))
>
> Line length above 80 chars.
>
> > +             return -ENOBUFS;
> > +
> > +     data =3D nla_nest_start(msg, NL80211_PMSR_REQ_ATTR_DATA);
> > +     if (!data)
> > +             return -ENOBUFS;
> > +
> > +     err =3D mac80211_hwsim_send_pmsr_ftm_request_peer(msg, &request->=
ftm);
> > +     if (err)
> > +             return err;
> > +
> > +     nla_nest_end(msg, data);
> > +     nla_nest_end(msg, req);
> > +     nla_nest_end(msg, peer);
> > +
> > +     return 0;
> > +}
> > +
> > +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> > +                                         struct cfg80211_pmsr_request =
*request)
> > +{
> > +     int err;
> > +     struct nlattr *pmsr =3D nla_nest_start(msg, NL80211_ATTR_PEER_MEA=
SUREMENTS);
>
> Please follow the RCT principle.
> Also, I would suggest to split declaration of "pmsr" and assignment becau=
se
> "nla_nest_start() is a call that is more in the action part of the code
> than the declaration part.
>
> > +
> > +     if (!pmsr)
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u32(msg, NL80211_ATTR_TIMEOUT, request->timeout))
> > +             return -ENOBUFS;
> > +
> > +     if (!is_zero_ether_addr(request->mac_addr)) {
> > +             if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, request->mac=
_addr))
> > +                     return -ENOBUFS;
> > +             if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN, request=
->mac_addr_mask))
> > +                     return -ENOBUFS;
> > +     }
> > +
> > +     for (int i =3D 0; i < request->n_peers; i++) {
> > +             err =3D mac80211_hwsim_send_pmsr_request_peer(msg, &reque=
st->peers[i]);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     nla_nest_end(msg, pmsr);
> > +
> > +     return 0;
> > +}
> > +
> > +static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
> > +                                  struct ieee80211_vif *vif,
> > +                                  struct cfg80211_pmsr_request *reques=
t)
> > +{
> > +     struct mac80211_hwsim_data *data =3D hw->priv;
> > +     u32 _portid =3D READ_ONCE(data->wmediumd);
> > +     int err =3D 0;
> > +     struct sk_buff *skb =3D NULL;
> > +     void *msg_head;
> > +     struct nlattr *pmsr;
>
> Please use RCT.
>
> > +
> > +     if (!_portid && !hwsim_virtio_enabled)
> > +             return -EOPNOTSUPP;
> > +
> > +     mutex_lock(&data->mutex);
> > +
> > +     if (data->pmsr_request) {
> > +             err =3D -EBUSY;
> > +             goto out_err;
> > +     }
> > +
> > +     skb =3D genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > +
> > +     if (!skb) {
> > +             err =3D -ENOMEM;
> > +             goto out_err;
> > +     }
> > +
> > +     msg_head =3D genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
> > +                            HWSIM_CMD_START_PMSR);
> > +
> > +     if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
> > +                 ETH_ALEN, data->addresses[1].addr)) {
> > +             err =3D -ENOMEM;
> > +             goto out_err;
> > +     }
> > +
> > +     pmsr =3D nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
> > +     if (!pmsr) {
> > +             err =3D -ENOMEM;
> > +             goto out_err;
> > +     }
> > +
> > +     err =3D mac80211_hwsim_send_pmsr_request(skb, request);
> > +     if (err)
> > +             goto out_err;
> > +
> > +     nla_nest_end(skb, pmsr);
> > +
> > +     genlmsg_end(skb, msg_head);
> > +     if (hwsim_virtio_enabled)
> > +             hwsim_tx_virtio(data, skb);
> > +     else
> > +             hwsim_unicast_netgroup(data, skb, _portid);
> > +
> > +out_err:
> > +     if (err && skb)
> > +             nlmsg_free(skb);
> > +
> > +     if (!err) {
> > +             data->pmsr_request =3D request;
> > +             data->pmsr_request_wdev =3D ieee80211_vif_to_wdev(vif);
> > +     }
>
> It looks confusing to have such a check under "out_err" label.
> I would expect error handling only under "out_err".

renamed out_err to out_free, to keep the mutex_unlock() code under the out_=
err.

> Please improve both checks above:
>  - handle normal cases e.g. "ieee80211_vif_to_wdev()" above the eror
>    label.

done

>  - try to avoid checking if error occured if you are already in the
>    error path.
>
> > +
> > +     mutex_unlock(&data->mutex);
> > +     return err;
> > +}
> > +
> >  #define HWSIM_COMMON_OPS                                     \
> >       .tx =3D mac80211_hwsim_tx,                                \
> >       .wake_tx_queue =3D ieee80211_handle_wake_tx_queue,        \
> > @@ -3161,7 +3365,8 @@ static int mac80211_hwsim_change_sta_links(struct=
 ieee80211_hw *hw,
> >       .flush =3D mac80211_hwsim_flush,                          \
> >       .get_et_sset_count =3D mac80211_hwsim_get_et_sset_count,  \
> >       .get_et_stats =3D mac80211_hwsim_get_et_stats,            \
> > -     .get_et_strings =3D mac80211_hwsim_get_et_strings,
> > +     .get_et_strings =3D mac80211_hwsim_get_et_strings,        \
> > +     .start_pmsr =3D mac80211_hwsim_start_pmsr,                \
> >
> >  #define HWSIM_NON_MLO_OPS                                    \
> >       .sta_add =3D mac80211_hwsim_sta_add,                      \
> > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wirele=
ss/mac80211_hwsim.h
> > index d10fa7f4853b..98e586a56582 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.h
> > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > @@ -81,6 +81,8 @@ enum hwsim_tx_control_flags {
> >   *   to this receiver address for a given station.
> >   * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attribut=
es
> >   *   are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
> > + * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
> > + *   %HWSIM_ATTR_PMSR_REQUEST.
> >   * @__HWSIM_CMD_MAX: enum limit
> >   */
> >  enum {
> > @@ -93,6 +95,7 @@ enum {
> >       HWSIM_CMD_GET_RADIO,
> >       HWSIM_CMD_ADD_MAC_ADDR,
> >       HWSIM_CMD_DEL_MAC_ADDR,
> > +     HWSIM_CMD_START_PMSR,
> >       __HWSIM_CMD_MAX,
> >  };
> >  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> > @@ -144,6 +147,8 @@ enum {
> >   *   the new radio
> >   * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD_CRE=
ATE_RADIO
> >   *   to provide peer measurement capabilities. (nl80211_peer_measureme=
nt_attrs)
> > + * @HWSIM_ATTR_PMSR_REQUEST: nested attribute used with %HWSIM_CMD_STA=
RT_PMSR
> > + *   to provide details about peer measurement request (nl80211_peer_m=
easurement_attrs)
> >   * @__HWSIM_ATTR_MAX: enum limit
> >   */
> >
> > @@ -176,6 +181,7 @@ enum {
> >       HWSIM_ATTR_CIPHER_SUPPORT,
> >       HWSIM_ATTR_MLO_SUPPORT,
> >       HWSIM_ATTR_PMSR_SUPPORT,
> > +     HWSIM_ATTR_PMSR_REQUEST,
> >       __HWSIM_ATTR_MAX,
> >  };
> >  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> > --
> > 2.40.0.rc1.284.g88254d51c5-goog
> >


Applied reverse xmas tree style and renamed goto label.
Line limits are unchanged because 80 is deprecated now.


--
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
