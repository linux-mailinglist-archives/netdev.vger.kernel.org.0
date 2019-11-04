Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A26EE901
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfKDTyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:54:02 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46073 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfKDTyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:54:02 -0500
Received: by mail-lf1-f68.google.com with SMTP id v8so13158054lfa.12
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 11:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XsApX15akz0L3GPW7qIpCxIKxjdrS16x2xoEJ0ELfI0=;
        b=wdg1Hgb15y4/c5g7Uzwzw2pMvFxp4UC1qXbLhC3OLEQd0W/B4MfZS2DarcvFb1o9S9
         egtDX2Z1x9HEEzlajpuPwbrefM5Ddbnb7Qj3ExTnGpG7ykEZzPn4IwhnVDHdKRV0vnn2
         DZ3AQm/HjFMlGWOQsWULTEMfhDTvCcWTbRkLr7FRC3qUZswWW9qHNS7MWZsSC8VeTrQY
         pOmP4efTX/7U7N21hUjQ1AlqPQc6OeUihggrFadwVaShvLZvvnfY/NiS0pADts6KOYlV
         1x55L2B3nJTfZEI04h1vj1bnkWafmN2s+mvg+pD8KPBotXD7LF8F6gqPMiVQ9PtJLHYZ
         0AiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XsApX15akz0L3GPW7qIpCxIKxjdrS16x2xoEJ0ELfI0=;
        b=Nh/yY9+FA2VlFXHG4jbp8iPdGLdr6gWk0cALCNCNLCOduaX/rdPMLXeOrLhisiUo25
         sv9DdN9WlOoU9ZEWsLipVtp7Iqew8Heh85/UmfYs+YZ+3actQnqGr3TmkgsURpMpNi01
         MBh4Mo3Xv8VzCQ6D4+wksBafzDXssfVpemxMgcGCNjyXq9rbPYPVxHn86wKPKSge/1H2
         /DGX78MOE8qfxmBJVUTe5uoZpmWeBPUqTuSCviYoCck5zTdz1ppwQmUMPeSUt+Ur/96Q
         UVnxsUqEmXWhhvYCu9UAHAPA1LV5f2KTtb3IOXhAbhMhU2CorZDmBTN00mEamE9DeDBh
         wVpA==
X-Gm-Message-State: APjAAAUZtfOv0eFLfLZU8b11Ur8ReeZSicE5atoIHcVtWEgGd4lBiQhh
        14YKYaTGB0CnixJXFX0k3G0ryg==
X-Google-Smtp-Source: APXvYqypqFnljjnNOSxF/KZBP91xb4b/vDuSgGt1lZssDbxpQA8rlYaqnoXQyWK7YW+nd8W4X66B6Q==
X-Received: by 2002:ac2:4651:: with SMTP id s17mr9911478lfo.46.1572897239687;
        Mon, 04 Nov 2019 11:53:59 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y189sm12309205lfc.9.2019.11.04.11.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 11:53:59 -0800 (PST)
Date:   Mon, 4 Nov 2019 11:53:52 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 5/7] ixgbe: protect TX timestamping from API misuse
Message-ID: <20191104115352.49129186@cakuba.netronome.com>
In-Reply-To: <20191102121417.15421-6-jeffrey.t.kirsher@intel.com>
References: <20191102121417.15421-1-jeffrey.t.kirsher@intel.com>
        <20191102121417.15421-6-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 Nov 2019 05:14:15 -0700, Jeff Kirsher wrote:
> From: Manjunath Patil <manjunath.b.patil@oracle.com>
> 
> HW timestamping can only be requested for a packet if the NIC is first
> setup via ioctl(SIOCSHWTSTAMP). If this step was skipped, then the ixgbe
> driver still allowed TX packets to request HW timestamping. In this
> situation, we see 'clearing Tx Timestamp hang' noise in the log.
> 
> Fix this by checking that the NIC is configured for HW TX timestamping
> before accepting a HW TX timestamping request.
> 
> similar-to:
> 	(26bd4e2 igb: protect TX timestamping from API misuse)
> 	(0a6f2f0 igb: Fix a test with HWTSTAMP_TX_ON)

This is not a correct way to quote a commit. Please use checkpatch.

All the other patches look good!
