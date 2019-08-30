Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6979A3A81
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfH3Pjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:39:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43871 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbfH3Pjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:39:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id v12so4869067pfn.10;
        Fri, 30 Aug 2019 08:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=uNsHy93+wktGqXiYvmtr4b3L1IzhmZcwILohx4H4wmY=;
        b=lYbOj/IMhp9IDnPB+UO5RSpm+BG/867DPubItHr8tLkYK8nPELrQpatyEkw5DDqYct
         SamRSuB7mVvCx07R3gdfzHS9YsB/VIsyWHaLaf99M/6q+45ky/m7DqDIWKtd/b21ACJ4
         NWhRt4kusOTKSDWWNP2G1z1gzXUwPO8FJUIF5exjEElQggvkWYI690ewZ2cI5IrAUT0K
         4KlSsCfKcTmXqgE6UaxkxSIsAVWCrn1RFAL3SopWuaMs5VC4rYsYgVGOOIxuMrwCuiMH
         mnkL2dlV2Omx5Jv5AmAkMM7oLnCn6LHVdvoHIx6qK0qv7KjaaWg6NKPA+USzOxDknr84
         sFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=uNsHy93+wktGqXiYvmtr4b3L1IzhmZcwILohx4H4wmY=;
        b=YrmHmEpo0yBR9Un1AxurVkMgYcRAilxVpMZfhsoNHCcW5WASriNpje0l0vgdz+Or2b
         cwdUs6ZcXtg4aa978JCzZxllmBg2WoODNOdP0saZO8+xRmuRlwhgis/BFDSpyQz65g+a
         XALnQvVGKzpIoRvS9saNeki3Cm25+Ts34b+yca/eaBi+4ocHgxY8NCULBVk1TWrW3Ybo
         n9PxdBmmcQmzT4JWQcZPGiQY1xZh9CRC0SFL+QvJ4+LmG/TX4UNN8WvU7KbOErll47Yv
         msibDxUEIEhqjjwDmjPSc+e/sgc4Z6ujKfoBAzIazoq/Eh8MhrzBCBQYY1+axKs1Q7dD
         QBZA==
X-Gm-Message-State: APjAAAUm+vy11H6dh6LsqeYSAjyMFhL3mBDGD0VWB3taDVH8K0fdpt79
        vjycvntb8UsvXIx2uzaVtgo=
X-Google-Smtp-Source: APXvYqxlW2ZBIKtt+d+rHt7P/b68lKF9GR0tkVHPkKDvM5IjUhG460DPrbB/kqDma0P56tXpVk3jrg==
X-Received: by 2002:a62:641:: with SMTP id 62mr18685092pfg.55.1567179579470;
        Fri, 30 Aug 2019 08:39:39 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id m145sm7171401pfd.68.2019.08.30.08.39.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:39:38 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 02/12] ixgbe: simplify Rx buffer recycle
Date:   Fri, 30 Aug 2019 08:39:37 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <C44AEBC2-7D1B-4DEE-B2A5-CFEF4A571383@gmail.com>
In-Reply-To: <20190827022531.15060-3-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-3-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> Currently, the dma, addr and handle are modified when we reuse Rx buffers
> in zero-copy mode. However, this is not required as the inputs to the
> function are copies, not the original values themselves. As we use the
> copies within the function, we can use the original 'obi' values
> directly without having to mask and add the headroom.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
