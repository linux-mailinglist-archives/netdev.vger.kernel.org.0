Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B95A2919
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfH2VhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:37:11 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33084 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfH2VhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 17:37:10 -0400
Received: by mail-ed1-f68.google.com with SMTP id l26so5038693edr.0
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 14:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cT6eLCBIJ3qNP0Ooe8ZP2N9t7L6L/Dp/XPGtUWkrjgY=;
        b=IJ9nuvAE/gzJsTVWc1n2knoSPSExR32ZgQFhdXdsc7jXQk2lGtiFIOCRzI1rBR9jJm
         oOnB8b5r4Sx0DYf4r7/SfibPt0fZkf62BrUQvRvr8YbYvYU5KRc/4z+9sGmfdA+001iP
         G3lpW8BuPfreWuA/VgVEcYQFd6k3XXKFfDQ2lEl+DeroQ6PGb7PxTd9zRHgZddEkwBfh
         BRTDeSNv9/tgfcUFZzn/JOfeID++wasxdxbk6DzUmWbA4L33cRlhqOFBQPch/P6lazUT
         sj8789kxkb+B90HNimmzY5A7/oxgKjegAOj3Ijpbc+H9B4jCiySOn9DbVV5AXY7fZ8SA
         tXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cT6eLCBIJ3qNP0Ooe8ZP2N9t7L6L/Dp/XPGtUWkrjgY=;
        b=WjfXF8MyDzS/RlOlwCf+rtbpjxKcia0rCUwCUw5KpAbrKoJ4B+qCPUAuiSyleIbeuB
         f/hD/tGmkGUkbyYUofvhGzma765Xb/Z3J/+kdp4zNHztHrmzHy8KtkbRcXYd7Tg407zt
         4V6VYLHAA0rJcKLbMP9RSVOoZtqdAxnhTsgzh96chsMhBLmCdbrKi7d+62WCLgR3aZpB
         3kBubrp56hLHouvhXVYrlYVD4kyXBEptG1W6mXsY/JV7ekcv4wCLGLH9KSvVzBhMxTNd
         F4SFnxdCgUhSK90mA99CUmhUZi6ZheYyJuT6dpUxkctgSAxkOI5tK5XZb2DalYW0ZlFI
         bRrA==
X-Gm-Message-State: APjAAAXt/hX1C75JjZmaRXbozDeaUqE9JYkAOlsEqHAHyyanIl9DvsVc
        /6+0UO03bD3ZyJKCX+x/ym6omQ==
X-Google-Smtp-Source: APXvYqz6HBhC825WivoPJBDrN+wzFG14aIInPgvha7E4DafJBukIorY90OdnYIkDQ7EuAF3uT6diNA==
X-Received: by 2002:a17:906:490d:: with SMTP id b13mr4210618ejq.16.1567114628345;
        Thu, 29 Aug 2019 14:37:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o88sm648991edb.28.2019.08.29.14.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 14:37:08 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:36:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, oss-drivers@netronome.com,
        jaco.gericke@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next 2/2] nfp: bpf: add simple map op cache
Message-ID: <20190829143643.7cdd8669@cakuba.netronome.com>
In-Reply-To: <CAPhsuW5ExXPXYi5D2MND5JREh8EKNHUvSNoBEJ7L3-XK3GD9mA@mail.gmail.com>
References: <20190828053629.28658-1-jakub.kicinski@netronome.com>
        <20190828053629.28658-3-jakub.kicinski@netronome.com>
        <CAPhsuW5ExXPXYi5D2MND5JREh8EKNHUvSNoBEJ7L3-XK3GD9mA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 14:29:44 -0700, Song Liu wrote:
> On Tue, Aug 27, 2019 at 10:40 PM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> >
> > Each get_next and lookup call requires a round trip to the device.
> > However, the device is capable of giving us a few entries back,
> > instead of just one.
> >
> > In this patch we ask for a small yet reasonable number of entries
> > (4) on every get_next call, and on subsequent get_next/lookup calls
> > check this little cache for a hit. The cache is only kept for 250us,
> > and is invalidated on every operation which may modify the map
> > (e.g. delete or update call). Note that operations may be performed
> > simultaneously, so we have to keep track of operations in flight.
> >
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> > ---
> >  drivers/net/ethernet/netronome/nfp/bpf/cmsg.c | 179 +++++++++++++++++-
> >  drivers/net/ethernet/netronome/nfp/bpf/fw.h   |   1 +
> >  drivers/net/ethernet/netronome/nfp/bpf/main.c |  18 ++
> >  drivers/net/ethernet/netronome/nfp/bpf/main.h |  23 +++
> >  .../net/ethernet/netronome/nfp/bpf/offload.c  |   3 +
> >  5 files changed, 215 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
> > index fcf880c82f3f..0e2db6ea79e9 100644
> > --- a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
> > +++ b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/bug.h>
> >  #include <linux/jiffies.h>
> >  #include <linux/skbuff.h>
> > +#include <linux/timekeeping.h>
> >
> >  #include "../ccm.h"
> >  #include "../nfp_app.h"
> > @@ -175,29 +176,151 @@ nfp_bpf_ctrl_reply_val(struct nfp_app_bpf *bpf, struct cmsg_reply_map_op *reply,
> >         return &reply->data[bpf->cmsg_key_sz * (n + 1) + bpf->cmsg_val_sz * n];
> >  }
> >
> > +static bool nfp_bpf_ctrl_op_cache_invalidate(enum nfp_ccm_type op)
> > +{
> > +       return op == NFP_CCM_TYPE_BPF_MAP_UPDATE ||
> > +              op == NFP_CCM_TYPE_BPF_MAP_DELETE;
> > +}
> > +
> > +static bool nfp_bpf_ctrl_op_cache_capable(enum nfp_ccm_type op)
> > +{
> > +       return op == NFP_CCM_TYPE_BPF_MAP_LOOKUP ||
> > +              op == NFP_CCM_TYPE_BPF_MAP_GETNEXT;
> > +}
> > +
> > +static bool nfp_bpf_ctrl_op_cache_fill(enum nfp_ccm_type op)
> > +{
> > +       return op == NFP_CCM_TYPE_BPF_MAP_GETFIRST ||
> > +              op == NFP_CCM_TYPE_BPF_MAP_GETNEXT;
> > +}
> > +
> > +static unsigned int
> > +nfp_bpf_ctrl_op_cache_get(struct nfp_bpf_map *nfp_map, enum nfp_ccm_type op,
> > +                         const u8 *key, u8 *out_key, u8 *out_value,
> > +                         u32 *cache_gen)
> > +{
> > +       struct bpf_map *map = &nfp_map->offmap->map;
> > +       struct nfp_app_bpf *bpf = nfp_map->bpf;
> > +       unsigned int i, count, n_entries;
> > +       struct cmsg_reply_map_op *reply;
> > +
> > +       n_entries = nfp_bpf_ctrl_op_cache_fill(op) ? bpf->cmsg_cache_cnt : 1;
> > +
> > +       spin_lock(&nfp_map->cache_lock);
> > +       *cache_gen = nfp_map->cache_gen;
> > +       if (nfp_map->cache_blockers)
> > +               n_entries = 1;
> > +
> > +       if (nfp_bpf_ctrl_op_cache_invalidate(op))
> > +               goto exit_block;
> > +       if (!nfp_bpf_ctrl_op_cache_capable(op))
> > +               goto exit_unlock;
> > +
> > +       if (!nfp_map->cache)
> > +               goto exit_unlock;
> > +       if (nfp_map->cache_to < ktime_get_ns())
> > +               goto exit_invalidate;
> > +
> > +       reply = (void *)nfp_map->cache->data;
> > +       count = be32_to_cpu(reply->count);  
> 
> Do we need to check whether count is too big (from firmware bug)?

It's validated below, when the skb is received (see my "here" below)

> > +
> > +       for (i = 0; i < count; i++) {
> > +               void *cached_key;
> > +
> > +               cached_key = nfp_bpf_ctrl_reply_key(bpf, reply, i);
> > +               if (memcmp(cached_key, key, map->key_size))
> > +                       continue;
> > +
> > +               if (op == NFP_CCM_TYPE_BPF_MAP_LOOKUP)
> > +                       memcpy(out_value, nfp_bpf_ctrl_reply_val(bpf, reply, i),
> > +                              map->value_size);
> > +               if (op == NFP_CCM_TYPE_BPF_MAP_GETNEXT) {
> > +                       if (i + 1 == count)
> > +                               break;
> > +
> > +                       memcpy(out_key,
> > +                              nfp_bpf_ctrl_reply_key(bpf, reply, i + 1),
> > +                              map->key_size);
> > +               }
> > +
> > +               n_entries = 0;
> > +               goto exit_unlock;
> > +       }
> > +       goto exit_unlock;
> > +
> > +exit_block:
> > +       nfp_map->cache_blockers++;
> > +exit_invalidate:
> > +       dev_consume_skb_any(nfp_map->cache);
> > +       nfp_map->cache = NULL;
> > +exit_unlock:
> > +       spin_unlock(&nfp_map->cache_lock);
> > +       return n_entries;
> > +}

> >  static int
> >  nfp_bpf_ctrl_entry_op(struct bpf_offloaded_map *offmap, enum nfp_ccm_type op,
> >                       u8 *key, u8 *value, u64 flags, u8 *out_key, u8 *out_value)
> >  {
> >         struct nfp_bpf_map *nfp_map = offmap->dev_priv;
> > +       unsigned int n_entries, reply_entries, count;
> >         struct nfp_app_bpf *bpf = nfp_map->bpf;
> >         struct bpf_map *map = &offmap->map;
> >         struct cmsg_reply_map_op *reply;
> >         struct cmsg_req_map_op *req;
> >         struct sk_buff *skb;
> > +       u32 cache_gen;
> >         int err;
> >
> >         /* FW messages have no space for more than 32 bits of flags */
> >         if (flags >> 32)
> >                 return -EOPNOTSUPP;
> >
> > +       /* Handle op cache */
> > +       n_entries = nfp_bpf_ctrl_op_cache_get(nfp_map, op, key, out_key,
> > +                                             out_value, &cache_gen);
> > +       if (!n_entries)
> > +               return 0;
> > +
> >         skb = nfp_bpf_cmsg_map_req_alloc(bpf, 1);
> > -       if (!skb)
> > -               return -ENOMEM;
> > +       if (!skb) {
> > +               err = -ENOMEM;
> > +               goto err_cache_put;
> > +       }
> >
> >         req = (void *)skb->data;
> >         req->tid = cpu_to_be32(nfp_map->tid);
> > -       req->count = cpu_to_be32(1);
> > +       req->count = cpu_to_be32(n_entries);
> >         req->flags = cpu_to_be32(flags);
> >
> >         /* Copy inputs */
> > @@ -207,16 +330,38 @@ nfp_bpf_ctrl_entry_op(struct bpf_offloaded_map *offmap, enum nfp_ccm_type op,
> >                 memcpy(nfp_bpf_ctrl_req_val(bpf, req, 0), value,
> >                        map->value_size);
> >
> > -       skb = nfp_ccm_communicate(&bpf->ccm, skb, op,
> > -                                 nfp_bpf_cmsg_map_reply_size(bpf, 1));
> > -       if (IS_ERR(skb))
> > -               return PTR_ERR(skb);
> > +       skb = nfp_ccm_communicate(&bpf->ccm, skb, op, 0);
> > +       if (IS_ERR(skb)) {
> > +               err = PTR_ERR(skb);
> > +               goto err_cache_put;
> > +       }
> > +
> > +       if (skb->len < sizeof(*reply)) {
> > +               cmsg_warn(bpf, "cmsg drop - type 0x%02x too short %d!\n",
> > +                         op, skb->len);
> > +               err = -EIO;
> > +               goto err_free;
> > +       }
> >
> >         reply = (void *)skb->data;
> > +       count = be32_to_cpu(reply->count);
> >         err = nfp_bpf_ctrl_rc_to_errno(bpf, &reply->reply_hdr);
> > +       /* FW responds with message sized to hold the good entries,
> > +        * plus one extra entry if there was an error.
> > +        */
> > +       reply_entries = count + !!err;
> > +       if (n_entries > 1 && count)
> > +               err = 0;
> >         if (err)
> >                 goto err_free;
> >
> > +       if (skb->len != nfp_bpf_cmsg_map_reply_size(bpf, reply_entries)) {

here, reply_entries is derived directly from reply->count

> > +               cmsg_warn(bpf, "cmsg drop - type 0x%02x too short %d for %d entries!\n",
> > +                         op, skb->len, reply_entries);
> > +               err = -EIO;
> > +               goto err_free;
> > +       }
> > +
> >         /* Copy outputs */
> >         if (out_key)
> >                 memcpy(out_key, nfp_bpf_ctrl_reply_key(bpf, reply, 0),
> > @@ -225,11 +370,13 @@ nfp_bpf_ctrl_entry_op(struct bpf_offloaded_map *offmap, enum nfp_ccm_type op,
> >                 memcpy(out_value, nfp_bpf_ctrl_reply_val(bpf, reply, 0),
> >                        map->value_size);
> >
> > -       dev_consume_skb_any(skb);
> > +       nfp_bpf_ctrl_op_cache_put(nfp_map, op, skb, cache_gen);
> >
> >         return 0;
> >  err_free:
> >         dev_kfree_skb_any(skb);
> > +err_cache_put:
> > +       nfp_bpf_ctrl_op_cache_put(nfp_map, op, NULL, cache_gen);
> >         return err;
> >  }
> >
> > @@ -275,7 +422,21 @@ unsigned int nfp_bpf_ctrl_cmsg_min_mtu(struct nfp_app_bpf *bpf)
> >
> >  unsigned int nfp_bpf_ctrl_cmsg_mtu(struct nfp_app_bpf *bpf)
> >  {
> > -       return max(NFP_NET_DEFAULT_MTU, nfp_bpf_ctrl_cmsg_min_mtu(bpf));
> > +       return max3(NFP_NET_DEFAULT_MTU,
> > +                   nfp_bpf_cmsg_map_req_size(bpf, NFP_BPF_MAP_CACHE_CNT),
> > +                   nfp_bpf_cmsg_map_reply_size(bpf, NFP_BPF_MAP_CACHE_CNT));
> > +}
> > +
> > +unsigned int nfp_bpf_ctrl_cmsg_cache_cnt(struct nfp_app_bpf *bpf)
> > +{
> > +       unsigned int mtu, req_max, reply_max, entry_sz;
> > +
> > +       mtu = bpf->app->ctrl->dp.mtu;
> > +       entry_sz = bpf->cmsg_key_sz + bpf->cmsg_val_sz;
> > +       req_max = (mtu - sizeof(struct cmsg_req_map_op)) / entry_sz;
> > +       reply_max = (mtu - sizeof(struct cmsg_reply_map_op)) / entry_sz;
> > +
> > +       return min3(req_max, reply_max, NFP_BPF_MAP_CACHE_CNT);
> >  }
> >
> >  void nfp_bpf_ctrl_msg_rx(struct nfp_app *app, struct sk_buff *skb)
> > diff --git a/drivers/net/ethernet/netronome/nfp/bpf/fw.h b/drivers/net/ethernet/netronome/nfp/bpf/fw.h
> > index 06c4286bd79e..a83a0ad5e27d 100644
> > --- a/drivers/net/ethernet/netronome/nfp/bpf/fw.h
> > +++ b/drivers/net/ethernet/netronome/nfp/bpf/fw.h
> > @@ -24,6 +24,7 @@ enum bpf_cap_tlv_type {
> >         NFP_BPF_CAP_TYPE_QUEUE_SELECT   = 5,
> >         NFP_BPF_CAP_TYPE_ADJUST_TAIL    = 6,
> >         NFP_BPF_CAP_TYPE_ABI_VERSION    = 7,
> > +       NFP_BPF_CAP_TYPE_CMSG_MULTI_ENT = 8,
> >  };
> >
> >  struct nfp_bpf_cap_tlv_func {
> > diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> > index 2b1773ed3de9..8f732771d3fa 100644
> > --- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
> > +++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> > @@ -299,6 +299,14 @@ nfp_bpf_parse_cap_adjust_tail(struct nfp_app_bpf *bpf, void __iomem *value,
> >         return 0;
> >  }
> >
> > +static int
> > +nfp_bpf_parse_cap_cmsg_multi_ent(struct nfp_app_bpf *bpf, void __iomem *value,
> > +                                u32 length)
> > +{
> > +       bpf->cmsg_multi_ent = true;
> > +       return 0;
> > +}
> > +
> >  static int
> >  nfp_bpf_parse_cap_abi_version(struct nfp_app_bpf *bpf, void __iomem *value,
> >                               u32 length)
> > @@ -375,6 +383,11 @@ static int nfp_bpf_parse_capabilities(struct nfp_app *app)
> >                                                           length))
> >                                 goto err_release_free;
> >                         break;
> > +               case NFP_BPF_CAP_TYPE_CMSG_MULTI_ENT:
> > +                       if (nfp_bpf_parse_cap_cmsg_multi_ent(app->priv, value,
> > +                                                            length))  
> 
> Do we plan to extend nfp_bpf_parse_cap_cmsg_multi_ent() to return
> non-zero in the
> future?

Yes, the TLV format allows for the entry to be extended and then
parsing may fail. It's mostly a pattern the BPF TLV parsing follows,
though.
