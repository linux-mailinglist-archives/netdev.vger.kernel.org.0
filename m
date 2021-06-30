Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FC83B7F33
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 10:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhF3IpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 04:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbhF3IpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 04:45:00 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6693BC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 01:42:31 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id m9so3720704ybo.5
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 01:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=DZYDHOnTbVkVpVFhPxoDi7EtNukpt2MfenaXL6gWgXs=;
        b=byvQlHYc88VWwxlAgxjeI01DelKMD8oOO3jER/Gmsv+BkohmLpeCOM6LNO6G9RJeyP
         /abTB4t+0RgYg/xW/Wwyl1YnUerEZf3oUZFf6QMfkZfMNgi7os6BUGw+J8BUzTA0V0t1
         xM5kIbXstmVhpxbr7vEEnAS3bVKtSctfztjSTCp2t5KiVPP8HTHdsUL1w0f7I/DG8lbK
         5M9CdzcYzg7eVkmq58WyNrzwKP/YIbZazT3yUcFyq/4b+LDetxp2MhfI4tGRaCYdX7XE
         E86oDR3YDqr0/JTOSJ152B7F0SgahlfTAUNUUT38c2BmcmDQnhRhBP719tA8z1OXQAMu
         8WAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=DZYDHOnTbVkVpVFhPxoDi7EtNukpt2MfenaXL6gWgXs=;
        b=uiME7M5uYjDVbcDJ99QypkHS4RHvWYzt8DHduhueeWe2qaVbTG8Pzqf7/M2sozRIu7
         5y8nLpCyHj+xTOLOCpt/aHLiIjZVPCvCLDpBCbvefnGCyYRzaDi1dmZTbOOnpOJzZ9Ty
         xv6FRj9quG4yreU3GknWAm+6vjq60I83fSszdiraizhUeCeZelqSklu4UhPgXePT631K
         cUe6ZgRjnEBFgleFKqBodJb4qcuYpfRIz3hwyR/wqtxwzZerzYsQIyEsoJLqJ+DGG0Ti
         z5vFJvz8r/ZRtZhqvv6JeDGROtCyIG/FuquzwuNz7JGXFRobOwAm3eyZt/ZlXnyunObU
         GLFg==
X-Gm-Message-State: AOAM53347/oprEeb9tP1wRkOKM5f1VQyh8w6BooOcOGFnvMY3MGKrCj4
        kB1FnS7WQa4D0VQ8D1oaUU8rsIX+0iiMXQ4eYZF1SRRT3nyROFuDyR+Umw==
X-Google-Smtp-Source: ABdhPJxCIb57EZfmx+86/Ku12Ur/BShOBbpeTBFWb1qd9E/QhbCEWpm1otg8mPVD3sk3XAqQglzCU1g+xdbORyDDCdY=
X-Received: by 2002:a05:6902:100d:: with SMTP id w13mr44244332ybt.406.1625042550540;
 Wed, 30 Jun 2021 01:42:30 -0700 (PDT)
MIME-Version: 1.0
From:   mingkun bian <bianmingkun@gmail.com>
Date:   Wed, 30 Jun 2021 16:42:21 +0800
Message-ID: <CAL87dS3zUG65ADXD4E2EnBSO_4FBrB4k=uLc_cT0tr7gbPeMOA@mail.gmail.com>
Subject: [ISSUE] EDT will lead ca_rtt to 0 when different tx queue have
 different qdisc
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I found a problem that ca_rtt have a small chance to become 0 when
using EDT, then find that it is caused by different tx queue which
have different qdisc as following:

The case may be caused by my operation of the network card(ethtool -L
ethx combined 48)

    1. Network card original num_tx_queues is 64, real_num_tx_queues
is 24, so in "mq_init" and "mq_attach", only the first 24 queues are
set by default qdisc(fq),
and the last 40 queues are set to  pfifo_fast_ops.

    2. After the system starts, I exec "ethtool -L ethx combined 48"
to make the tx/rx queue to 48, but it does not modify qdisc's
configuration,
at this time for bbr, bbr will use fq when "
__dev_queue_xmit->netdev_pick_tx" select  the first 24 queues, and bbr
will use tcp stack's timer(qdisc is  pfifo_fast_ops) when   "
__dev_queue_xmit->netdev_pick_tx" select  the last24 queues,
and in this case, bbr works normally.

    3. The wrong scenario is:
    a. tcp select one of  the first 24 tx queues to send, then sch_fq
change sk->sk_pacing_status from SK_PACING_NEEDED to SK_PACING_FQ,
then tcp will use fq to send.
    b. after a while,  not sure for some reason=EF=BC=8C __dev_queue_xmit->
netdev_pick_tx select the last  24 queues which qdisc is
pfifo_fast_ops, then qdisc send this skb immediately(no pacing), then
ca_rtt =3D curtime - skb->timestamp_ns, skb->timestamp_ns may be bigger
than curtime.


Why does not get_default_qdisc_ops return all queues to the default qdisc?

get_default_qdisc_ops(const struct net_device *dev, int ntx)
{
return ntx < dev->real_num_tx_queues ?
default_qdisc_ops : &pfifo_fast_ops;
}

Thanks.
