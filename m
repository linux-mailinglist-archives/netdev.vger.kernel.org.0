Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BC13A79BF
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFOJFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhFOJFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 05:05:40 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55501C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 02:03:36 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so13577345oth.9
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 02:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rixdfmCs88HeFoVJrdbwSMdpQrOFpKvy1FBSYdYNoTg=;
        b=VA/kTpat/ah29H1kKZq/B+GRGE7YddtkjHyrBvvWPv8CAyJ+ShhINy6nuMXTGABGVz
         AUmo6x5pO/c0EdO+KPMSI3JUEMNXBRbH6PNAC0/HCFk4DgyAAF61XAab7+9Yp/knHAMG
         fx4jT8ghMSQ2G58+4sfDACt1J7MQb3Pss/rCTVIwzAClWn8j9Ys5yk5R6fQ2rZGIxhyn
         pwKxY0kinHnW/n10BL1PK4xfN4eugK+lppaX7d+wYLLZ55ck1dMStzFLYXmiNBW54dhP
         SwHWUXlqua5Lc+Pyb0qM37L1ILcshDr95X3XGMUeEc5FW7AvcxpIs7ZJwSouy0e15mH2
         mAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rixdfmCs88HeFoVJrdbwSMdpQrOFpKvy1FBSYdYNoTg=;
        b=Lm40ju/9Rgf3Uglee0Zy07BVFDRyo96W5qcAeHFsuaO5GhwBx/hJbnuQJgUHMhgQMY
         wbgiF9+vyBBScHBu4v/dq8CXpTEpY+5rizLFfDZgIYd4h3Ld12OC7ZwcElqLKhKTd6TG
         kGVC6UM3UrTB9owCNsFs9dleEqlQKrnK8+QeagXW9rHntfkOxI+w4p83UuODVLRdmw31
         6cUmyBSefayBwU3AacwdEmIirAmIwUOcDz9tNtxo3eSvWfOLmnI+LplWqa9QzDbP2XAk
         2uY084HqCZus7BXd4NSHRfZO0Kbx6Ic+P9eVNgSGXldR742zaHbFauWj82yW28la8xww
         MUSw==
X-Gm-Message-State: AOAM531ewJFXQQjqnBnlSKctNNmpZ/LZGS1+LJ78B481c0lxjtyk2ejX
        qVZptydOujkMom4uMVbOP46p2W5R6SiYWPD3N1A=
X-Google-Smtp-Source: ABdhPJx/zPMHpV8TYOwVA8P9zp2/Clm2EYSg8ruQYHUViD6ThX4jrJWjIylh5Us7yMjGbG/xBCx7tMceBoUzZJk2TGE=
X-Received: by 2002:a05:6830:cd:: with SMTP id x13mr17126052oto.166.1623747815600;
 Tue, 15 Jun 2021 02:03:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
 <8735tky064.fsf@miraculix.mork.no> <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 15 Jun 2021 11:03:24 +0200
Message-ID: <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Jun 14, 2021 at 10:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
> Agreed on the cloning being a strange solution. Kristian, were you able
> to reproduce the problem on upstream kernels?

Yes, after Bj=C3=B8rn's comment I realized that cloning was not a good
solution. I should have taken a closer look at the usbnet code, so
sorry about that. The most recent kernel I have managed to work well
with my boards is 5.4.123, but I see that 5.10 is available as well
(OpenWrt). However, I have backported all changes made to rmnet and
qmi_wwan between 5.4 and net-next as of yesterday. I was hoping that a
backport of the changes to those two drivers would be enough, but
perhaps there is something I have missed. I will try to get 5.10 to
run and see if that helps.

However, I have spent some more time looking into the code today.
Bj=C3=B8rn is right that calling netif_rx() from qmi_wwan is strange, at
least when in passthrough mode. The rx_fixup function will return 1
(assuming netif_rx() is successful), which in turn will lead to
usbnet_skb_return() being called and netif_rx() being called a second
time for the same skb. I have to admit that I don't know what will
happen when netif_rx() is called twice, but either call seems
redundant. I will submit a patch modifying the qmi_wwan rx_fixup
function to return 1 when the QMI_WWAN_FLAG_PASS_THROUGH. I believe it
is a nice clean-up and that is better to use as much of the existing
infrastructure as possible.

> It does look pretty strange that qmimux_rx_fixup() copies out all
> packets and receives them, and then let's usbnet to process the
> multi-frame skb without even fulling off the qmimux_hdr. I'm probably
> missing something.. otherwise sth like FLAG_MULTI_PACKET may be in
> order?

qmimux_rx_fixup() is different from what we are discussing here.
qmimux_rx_fixup() is used when the de-aggregation is performed by the
qmi_wwan driver, while the passthrough flag is set when the
de-aggregation is done by the rmnet driver. The logic in
qmimux_rx_fixup() is very similar to how the other usbnet mini-drivers
handles de-aggregation and also how de-aggregation is handled by for
example rmnet. I have no opinion on if the logic makes sens or not,
but at least the origin can be traced :)

Kristian
