Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA30931853F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBKGgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBKGgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:36:18 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5089DC061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:35:38 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 190so4078853wmz.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvV5zr6OEbNkDTVPVVDDZZwh0e/9oJq/CPIMYioyaPA=;
        b=fZ/asPI1ZunCFGvcQOJQyO3eCPpgo9nIjrbIMIT5ysSn31tR58qv12HD505tesObo3
         zb7oJstIXojkmylrIJgcQM7qa9DIrZjjDFb/kyKtPEHpGtwxlA2lSSDzfkbrysWkckWh
         2FBrEAnMv9GpUILVnejaZUZuNfhlL+jyBSTi8ibjH3NxF5r2QVOQuBD8c6b302fQGLde
         DkRxIssEGGlrRSh6hBqJpmlvQyIYt4Q3nwybdaMr7hpeqKkbVn/uD8paS/tW4o4CMYWZ
         +G0wH+4VqqsRMptlNi/UkMQ9c5iDEhF6sF9zR9mpJWp0q2VAxPKd+bg1zIufPLQbTQ17
         GOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvV5zr6OEbNkDTVPVVDDZZwh0e/9oJq/CPIMYioyaPA=;
        b=qCkWoWQF2HIGbE+jLSainb6lqZz58eMnkRF+G0ReI/BFClUspmjPIe+W2PAGI8CzCY
         +hW9L34bbVyEzIPo7WaRQhN6USNldKlMigb2YPZLaek207El+tAtDe2avu0+a8qzJzV4
         FWEx6z3DP/jc91uo7wvSAuR8iK69fRlwYRa57sFbF8huhRIVgc9YBei7HHUoZCNLsUi7
         mZA8mkTD6OhcP2oM6XrzAoM2cYxO3BFKGLNKbAk2DPJgzBqOgq0tkoEK08qUPkDjKa3g
         o2UiBxB/a0c1PheDkXrHpcztqk1PrAHM8NBdxAfhQKhGN/6Tyc0QihCFLU56JvrEi0Rj
         4M9g==
X-Gm-Message-State: AOAM530cUbzXVJb1ppXE0ZUxTg5u/mPzUZwUH9sgB2wHtw+Ail0ZHWtr
        0lef3PACWU7UxovZma22SeJzXO+LYTT6XJaitOg=
X-Google-Smtp-Source: ABdhPJzcf2jDWHcjYF5Iis3z2FIP1UFGpMwYulNxPVCqpGPoTJVD6KpFVOTfIfNux4RReOmRgt72ZdTzKL+J0Y3vRRY=
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr3146423wmh.113.1613025336897;
 Wed, 10 Feb 2021 22:35:36 -0800 (PST)
MIME-Version: 1.0
References: <20210211014144.881861-2-sukadev@linux.ibm.com>
In-Reply-To: <20210211014144.881861-2-sukadev@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 11 Feb 2021 00:35:25 -0600
Message-ID: <CAOhMmr5Z_nuzQ5EkX=tkv4v_OOyjP99ykQh3sCn9nsYgVLCxrA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ibmvnic: fix a race between open and reset
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 7:44 PM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> __ibmvnic_reset() currently reads the adapter->state before getting the
> rtnl and saves that state as the "target state" for the reset. If this
> read occurs when adapter is in PROBED state, the target state would be
> PROBED.
>
> Just after the target state is saved, and before the actual reset process
> is started (i.e before rtnl is acquired) if we get an ibmvnic_open() call
> we would move the adapter to OPEN state.
>
> But when the reset is processed (after ibmvnic_open()) drops the rtnl),
> it will leave the adapter in PROBED state even though we already moved
> it to OPEN.
>
> To fix this, use the RTNL to improve the serialization when reading/updating
> the adapter state. i.e determine the target state of a reset only after
> getting the RTNL. And if a reset is in progress during an open, simply
> set the target state of the adapter and let the reset code finish the
> open (like we currently do if failover is pending).
>
> One twist to this serialization is if the adapter state changes when we
> drop the RTNL to update the link state. Account for this by checking if
> there was an intervening open and update the target state for the reset
> accordingly (see new comments in the code). Note that only the reset
> functions and ibmvnic_open() can set the adapter to OPEN state and this
> must happen under rtnl.
>
> Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during device reset")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Reviewed-by: Dany Madden <drt@linux.ibm.com>
> ---
> Changelog[v3]
>         [Jakub Kicinski] Rebase to current net and fix comment style.
>
> Changelog[v2]
>         [Jakub Kicinski] Use ASSERT_RTNL() instead of WARN_ON_ONCE()
>         and rtnl_is_locked());
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 71 ++++++++++++++++++++++++++----
>  1 file changed, 63 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index a536fdbf05e1..96c2b0985484 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1197,12 +1197,25 @@ static int ibmvnic_open(struct net_device *netdev)
>         struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>         int rc;
>
> -       /* If device failover is pending, just set device state and return.
> -        * Device operation will be handled by reset routine.
> +       ASSERT_RTNL();
> +
> +       /* If device failover is pending or we are about to reset, just set
> +        * device state and return. Device operation will be handled by reset
> +        * routine.
> +        *
> +        * It should be safe to overwrite the adapter->state here. Since
> +        * we hold the rtnl, either the reset has not actually started or
> +        * the rtnl got dropped during the set_link_state() in do_reset().
> +        * In the former case, no one else is changing the state (again we
> +        * have the rtnl) and in the latter case, do_reset() will detect and
> +        * honor our setting below.
>          */
> -       if (adapter->failover_pending) {
> +       if (adapter->failover_pending || (test_bit(0, &adapter->resetting))) {
> +               netdev_dbg(netdev, "[S:%d FOP:%d] Resetting, deferring open\n",
> +                          adapter->state, adapter->failover_pending);
>                 adapter->state = VNIC_OPEN;
> -               return 0;
> +               rc = 0;
> +               goto out;
>         }
>
>         if (adapter->state != VNIC_CLOSED) {
> @@ -1221,11 +1234,12 @@ static int ibmvnic_open(struct net_device *netdev)
>         rc = __ibmvnic_open(netdev);
>
>  out:
> -       /*
> -        * If open fails due to a pending failover, set device state and
> -        * return. Device operation will be handled by reset routine.
> +       /* If open failed and there is a pending failover or in-progress reset,
> +        * set device state and return. Device operation will be handled by
> +        * reset routine. See also comments above regarding rtnl.
>          */
> -       if (rc && adapter->failover_pending) {
> +       if (rc &&
> +           (adapter->failover_pending || (test_bit(0, &adapter->resetting)))) {
>                 adapter->state = VNIC_OPEN;
>                 rc = 0;
>         }
> @@ -1939,6 +1953,14 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
>         netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
>                    rwi->reset_reason);
>
> +       /* read the state and check (again) after getting rtnl */
> +       reset_state = adapter->state;
> +
> +       if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
> +               rc = -EBUSY;
> +               goto out;
> +       }
> +

The changes in do_change_param_reset will cause merge conflict with
net-next tree since do_change_param_reset is no longer there in
net-next tree. I suggest sending this patch after net-next merges into
mainline, which should be soon.

>         netif_carrier_off(netdev);
>         adapter->reset_reason = rwi->reset_reason;
>
> @@ -2037,6 +2059,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>         if (rwi->reset_reason == VNIC_RESET_FAILOVER)
>                 adapter->failover_pending = false;
>
> +       /* read the state and check (again) after getting rtnl */
> +       reset_state = adapter->state;
> +
> +       if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
> +               rc = -EBUSY;
> +               goto out;
> +       }
> +
>         netif_carrier_off(netdev);
>         adapter->reset_reason = rwi->reset_reason;
>
> @@ -2063,7 +2093,24 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>                 if (rc)
>                         goto out;
>
> +               if (adapter->state == VNIC_OPEN) {
> +                       /* When we dropped rtnl, ibmvnic_open() got
> +                        * it and noticed that we are resetting and
> +                        * set the adapter state to OPEN. Update our
> +                        * new "target" state, and resume the reset
> +                        * from VNIC_CLOSING state.
> +                        */
> +                       netdev_dbg(netdev,
> +                                  "Open changed state from %d, updating.\n",
> +                                  reset_state);
> +                       reset_state = VNIC_OPEN;
> +                       adapter->state = VNIC_CLOSING;
> +               }
> +
>                 if (adapter->state != VNIC_CLOSING) {
> +                       /* If someone else changed the adapter state
> +                        * when we dropped the rtnl, fail the reset
> +                        */
>                         rc = -1;
>                         goto out;
>                 }
> @@ -2197,6 +2244,14 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
>         netdev_dbg(adapter->netdev, "Hard resetting driver (%d)\n",
>                    rwi->reset_reason);
>
> +       /* read the state and check (again) after getting rtnl */
> +       reset_state = adapter->state;
> +
> +       if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
> +               rc = -EBUSY;
> +               goto out;
> +       }
> +
>         netif_carrier_off(netdev);
>         adapter->reset_reason = rwi->reset_reason;
>
> --
> 2.26.2
>
