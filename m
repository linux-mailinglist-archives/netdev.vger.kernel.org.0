Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973F79C36C
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfHYNSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 09:18:07 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:44317 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfHYNSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 09:18:07 -0400
Received: by mail-lj1-f170.google.com with SMTP id e24so12704728ljg.11
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 06:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6Ki6/yGvKgy4gg6WYeW/sYfX8WObRl4jhtiR1b1X+3k=;
        b=WLL8qTLqOMXnmuYHpG8FnGULVpmWobHDKwyOJjh2AL8kE7M4LS9RsraPKDVHTmeUlB
         pAvP1zQnBFbxuOpajR2fdVIY+FuAh7Y7cGE0UX/bcj8eUWgXyscHzMkfYhphPUaZfxgH
         dcyd74x0CoD6VJW+mNcdUQs2MNSLgJjWiA5zu60Yfym8h4TuQ/yjtFkkNYn0h8dytJdU
         8zCTxuw2leApPnp+IOxa2CXCO5xI2HBUk+iZMQyUqtB/woilyMSS3z76Tsclz7VlQ64Y
         j+Su560y32nnP/d+HIjRYU/Vf4DiD5KW5Fihw5HVJPrCSNpKYKzLhSUMnsDp0X/CCWlw
         a8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6Ki6/yGvKgy4gg6WYeW/sYfX8WObRl4jhtiR1b1X+3k=;
        b=qo8ZBkKejP8JhcNb6VurTOvyAFrG6PwWTHsNbAU06l1VPqyK8qE3V25ElPoTKXNJE9
         J8+FOsTbJJ8qteUrYhFJeA+Kagx6Bwv1G1AJAnqMMX8/UQN2r1PWTVGzyte+0WLiN/wo
         wk9pXnK3lkMqIqyA+1XpglI4SbosicmWtqqDjnYrth3H/jWiSTDBKF+Aq5yCPrBXtmtR
         ster+fO+j1SuTs7WcMM7lV956UhO9hjZWbW4DbHmKJZj3z/qWZJUHheKIPpRplBVmXVt
         572WuWB4PtnpSiKB/gV0jbMqmdWhs0QZpogZAkx53sSnDCrhzu6ArkM8kfT+NcFHheWv
         O99A==
X-Gm-Message-State: APjAAAWsWf/UMTcbED1f1Exs2G0/7h1XZ/TqCr7xCHIqtTBK8dW3pdcz
        JWuG9JyWRxDMVtUHJoVxP6SXVoiYvgjeCApkwhBZeCBM
X-Google-Smtp-Source: APXvYqyiyQZ+bsoJpQ0bIX8MWGCvmasC2c8cUc4SvXcwjqtZf1z+XlwdTAzGgGW81+TVcuCC11yPF7dd51cSfDeHhWw=
X-Received: by 2002:a2e:4601:: with SMTP id t1mr8035104lja.102.1566739084222;
 Sun, 25 Aug 2019 06:18:04 -0700 (PDT)
MIME-Version: 1.0
From:   Roee Kashi <galacap@gmail.com>
Date:   Sun, 25 Aug 2019 16:17:52 +0300
Message-ID: <CA+f3hu+2y4_oh0bR=w=HYo9HDFuBzD9bkSaG_67PrGVDWGdu0Q@mail.gmail.com>
Subject: tx_fixup cdc_ether to mimic cdc_ncm tx behavior
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I ported from Intel based modem chipset (cdc_ncm) to a Qualcomm's one
(cdc_ether), and encountered a major difference between the two.

cdc_ncm had a nice "feature" (which probably wasn't the original
purpose): when trying to transmit more than the module's capacity,
tx_fixup would return NULL skb, hence fd buffer would remain full,
causing sendto/select to block until modem is available.
It's quite useful when sending UDP datagrams through an LTE link for
example, since the module provides a dynamic and reliable information
in real-time regarding its *incapability* of sending the datagram.

For example:
If my LTE link max upload bandwidth is 30Mbps, and i'll try with
cdc_ncm to transmit above that, the send/select would block until
modem is available, so the actual bandwidth would be 30Mbps with ~0%
packet loss.
with cdc_ncm: `iperf -u -c xxx -b 60Mbps` would report a TX bandwidth
~30Mbps with ~0% loss.

with cdc_ether, even though the modem is unable to transmit the
packet, nothing holds the tx flow: select continue and return fd as
available for tx, even though the modem's buffer is full.
with cdc_ether: `iperf -u -c xxx -b 60Mbps` would report a TX
bandwidth ~60Mbps with ~50% loss.

the difference between cdc_ncm and cdc_ether for this matter, is the
'cdc_ncm_tx_fixup' in cdc_ncm, documented as:
 /*
* The Ethernet API we are using does not support transmitting
* multiple Ethernet frames in a single call. This driver will
* accumulate multiple Ethernet frames and send out a larger
* USB frame when the USB buffer is full or when a single jiffies
* timeout happens.
*/

This fixup adds this useful side-effect to cdc_ncm, and I wonder how
to extend this specific behavior to cdc_ether as well, per flag.
What exactly in cdc_ncm: cdc_ncm_fill_tx_frame, causing this behavior,
and what is the community approach about adopting the described
cdc_ncm behavior?

(qmi_wwan behaves the same as cdc_ether)

Cheers,
Roee.
