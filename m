Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947DDEB49E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfJaQXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:23:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42186 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbfJaQXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:23:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id s23so982319pgo.9
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Z91byZ7QEDsuw+5ZBR8LzTIxHGSHUDnnJFQK9edY/gM=;
        b=Nk1dATDpnT0Aox2PeoN/D7VAMM0r66KO8STR/2ySH3fEdynqpc33Yupi9gN8WLsU1z
         ypgOl5QF7zzqMRoekobEnJBIfYWCORgOEi6L88fHliMnOv04jLnsmXcrKgZO0ODPwzXe
         fzDojM9z32KVPdbj4nLA2dTcKNvmncFRXyxq+h12mwqjOmAaLvLwvUD1kY5ktEkK4iIx
         Ce4YKmjwqLyIMv5IeO2skEuSux7WpKBQji5en4yJXnRtrYbAQdWPPSIYFGhwFOJS9h9M
         eaYV4z7DezBudbAhG3MPxeyzTTXP1lFtXIqXKm5/QcZwwQLcCXinNB6YgLlNb2uRthEO
         Xg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Z91byZ7QEDsuw+5ZBR8LzTIxHGSHUDnnJFQK9edY/gM=;
        b=bSQocLTVWhRkYrc7bQtGoJMEzrETtN2XvA67CHtWXQE4AdGXP3I2lQdfQi8ZY2/JiJ
         CJ9pI+CHJb4Tpbek+cLztGLZOohR9W5SvGcQrAodzHhVXKLoo/edzA8Os1LiZrZOLio1
         mZhBa+9EsfTcc715KLGXXSUy4fSYl3oI12QIasnq/cQnDa8OfQriPTdToIVL0C5lyW3Y
         +GMUbL96AsP9u+1OfLGSBMBVr7cCRi9nGBfbYaf0jNLjXPCYx8SmxOGuC6xIk28ewj07
         b32fVHfU4I/qeOG4QBqbNuej1qs8UZULtHPIL3YGwOVyaFwQu+brzhCn6A7wWkpNu+Ze
         yq0Q==
X-Gm-Message-State: APjAAAWn6iE0i0CLApjohZn4JCiQE6mmkl0GfG/MGHnk14A4+zQjOai/
        Qsm47d3ht9k1abvS6CJSxzxmTEtOQXQ=
X-Google-Smtp-Source: APXvYqwB5Rx7wcuFd286kamOHBgxrsJtfcXh9aVfz4b/dBLYHi8T4SqFEbZMEODsflmaqJVhE1Cong==
X-Received: by 2002:a62:e707:: with SMTP id s7mr7544099pfh.5.1572539022315;
        Thu, 31 Oct 2019 09:23:42 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id s13sm956835pfe.94.2019.10.31.09.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 09:23:42 -0700 (PDT)
Date:   Thu, 31 Oct 2019 09:23:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        sfr@canb.auug.org.au, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] netdevsim: Fix use-after-free during device
 dismantle
Message-ID: <20191031092338.79831fa7@cakuba.netronome.com>
In-Reply-To: <20191031162030.31158-1-idosch@idosch.org>
References: <20191031162030.31158-1-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 18:20:30 +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Commit da58f90f11f5 ("netdevsim: Add devlink-trap support") added
> delayed work to netdevsim that periodically iterates over the registered
> netdevsim ports and reports various packet traps via devlink.
> 
> While the delayed work takes the 'port_list_lock' mutex to protect
> against concurrent addition / deletion of ports, during device creation
> / dismantle ports are added / deleted without this lock, which can
> result in a use-after-free [1].
> 
> Fix this by making sure that the ports list is always modified under the
> lock.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
