Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFF037027B
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 22:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhD3Uzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 16:55:43 -0400
Received: from p3plsmtpa06-08.prod.phx3.secureserver.net ([173.201.192.109]:36079
        "EHLO p3plsmtpa06-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231265AbhD3Uzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 16:55:42 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id caA0lfFoUJECucaA1lfpRK; Fri, 30 Apr 2021 13:54:53 -0700
X-CMAE-Analysis: v=2.4 cv=aZ6kITkt c=1 sm=1 tr=0 ts=608c6e9d
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=eUCHAjWJAAAA:8
 a=677vOy6qcLM49a4hiOIA:9 a=M1CwSLUnbTk0EU51:21 a=AEblQBVlsbk3DWDm:21
 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=e1s5y4BJLze_2YVawdyF:22
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <netdev@vger.kernel.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>,
        <don@thebollingers.org>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
Subject: RE: [PATCH ethtool-next 0/4] Extend module EEPROM API
Date:   Fri, 30 Apr 2021 13:54:52 -0700
Message-ID: <008301d73e03$1196abb0$34c40310$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIoIhiQoNl9y+8EvClCms9DfxFPh6orvslQ
Content-Language: en-us
X-CMAE-Envelope: MS4xfJ4v3y53toCfRA6khZREw/6wXZ16w2vS3Tf6C3EnvBmFTVqCP8MQ4WRXREUzYJS3jzc96oXLy0FV49n+shIKHTFN2jqRFNRKkIr/OTlZE9dJjiUGbN1u
 EzJQTIvB/0rgtLNDsQqBT68rM2oRynDnP5Y8pBED8LyF2ggLpo6EuAvPZZo/mJf27HjAcq+TUCWIAMF7zp9j7EPYV3mekSxR4yIHUREvj8BQ6/ncp3Rh8rJv
 UrrtBbJLAEn8Cfzc29WLP2uJnIkTdHr0RNLcTq+eiCgn0Z9IzJVNGiCabPwsKaGgkr5VeBw/wKozjofK1BeHXxlZakxiDiH8q1MwiWTMGg9R+shOJ5RkkfXw
 Wx6m++ev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Moshe Shemesh [mailto:moshe@nvidia.com]
> Sent: Friday, April 23, 2021 12:23 AM
> To: Michal Kubecek <mkubecek@suse.cz>; Andrew Lunn
> <andrew@lunn.ch>; Jakub Kicinski <kuba@kernel.org>; Don Bollinger
> <don@thebollingers.org>; netdev@vger.kernel.org
> Cc: Vladyslav Tarasiuk <vladyslavt@nvidia.com>; Moshe Shemesh
> <moshe@nvidia.com>
> Subject: [PATCH ethtool-next 0/4] Extend module EEPROM API
> 
> Ethtool supports module EEPROM dumps via the `ethtool -m <dev>`
> command.
> But in current state its functionality is limited - offset and length
parameters,
> which are used to specify a linear desired region of EEPROM data to dump,
is
> not enough, considering emergence of complex module EEPROM layouts
> such as CMIS 4.0.
> 
> Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
> introducing another parameter for page addressing - banks.
> Besides, currently module EEPROM is represented as a chunk of
> concatenated pages, where lower 128 bytes of all pages, except page 00h,
> are omitted. Offset and length are used to address parts of this fake
linear
> memory. But in practice drivers, which implement
> get_module_info() and get_module_eeprom() ethtool ops still calculate
> page number and set I2C address on their own.
> 
> This series adds support in `ethtool -m` of dumping an arbitrary page
> specified by page number, bank number and I2C address. Implement netlink
> handler for `ethtool -m` in order to make such requests to the kernel and
> extend CLI by adding corresponding parameters.
> New command line format:
>  ethtool -m <dev> [hex on|off] [raw on|off] [offset N] [length N] [page N]
> [bank N] [i2c N]
> 
> Netlink infrastructure works on per-page basis and allows dumps of a
single
> page at once. But in case user requests human-readable output, which
> currently may require more than one page, userspace can make such
> additional calls to kernel on demand and place pages in a linked list.
> It allows to get pages from cache on demand and pass them to refactored
> SFF decoders.
> 
> Vladyslav Tarasiuk (4):
>   ethtool: Add netlink handler for getmodule (-m)
>   ethtool: Refactor human-readable module EEPROM output for new API
>   ethtool: Rename QSFP-DD identifiers to use CMIS 4.0
>   ethtool: Update manpages to reflect changes to getmodule (-m) command
> 
>  Makefile.am             |   3 +-
>  qsfp-dd.c => cmis4.c    | 220 +++++++++++---------
>  cmis4.h                 | 128 ++++++++++++
>  ethtool.8.in            |  14 ++
>  ethtool.c               |   4 +
>  internal.h              |  12 ++
>  list.h                  |  34 ++++
>  netlink/desc-ethtool.c  |  13 ++
>  netlink/extapi.h        |   2 +
>  netlink/module-eeprom.c | 438
> ++++++++++++++++++++++++++++++++++++++++
>  qsfp-dd.h               | 125 ------------
>  qsfp.c                  | 129 +++++++-----
>  qsfp.h                  |  52 ++---
>  sff-common.c            |   3 +
>  sff-common.h            |   3 +-
>  15 files changed, 876 insertions(+), 304 deletions(-)  rename qsfp-dd.c
=>
> cmis4.c (55%)  create mode 100644 cmis4.h  create mode 100644 list.h
create
> mode 100644 netlink/module-eeprom.c  delete mode 100644 qsfp-dd.h
> 
> --
> 2.26.2

Will there be an ethtool option to write to module eeprom in CMIS format?
There are routine functions to configure the devices that require writing
appropriate values to various registers.  Byte 26 allows software control of
low power mode, squelch and software reset.  Page 10h is full of Lane and
Data Path Control registers.

Beyond the spec, but allowed by the spec, there are vendor specific
capabilities like firmware download that require bulk write (up to 128 bytes
per write).

Using the full capabilities of these devices will require write capability.
Ethtool is the only path that will be allowed.

Don  


