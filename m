Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAC32A61B7
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgKDKgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgKDKf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 05:35:59 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 152E82072C;
        Wed,  4 Nov 2020 10:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604486159;
        bh=lMavT5+TN1mkhDAI95Bsjm5w5SanrwH1BvQflKDiYjs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wMIJltXfi18cWfPrnsJWYySAwXdAOMgHeB5c5sCjga8rmaW8mf0pP0GJ2FTQgCnR8
         xyt6JKN5V9XL7dR0Oa1ZMRu9nzCPQYcM/MSQM1mp+4heT8Fm7wpqmyDZEJYl4S5Ke6
         EYAD6HRrKz4VpzNyI7UrhTshh78Pim9EY5lN71Ew=
Date:   Wed, 4 Nov 2020 11:35:45 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201104113545.0428f3fe@kernel.org>
In-Reply-To: <20201104112511.78643f6e@kernel.org>
References: <20201103192226.2455-1-kabel@kernel.org>
        <20201103192226.2455-4-kabel@kernel.org>
        <20201103214712.dzwpkj6d5val6536@skbuf>
        <20201104065524.36a85743@kernel.org>
        <20201104084710.wr3eq4orjspwqvss@skbuf>
        <20201104112511.78643f6e@kernel.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Or something like this?

#define DEF_R_FUNC(_t, _r, _r_i, _mcu)				\
static inline _t _r(struct r8152 *tp, u16 index)		\
{								\
	return _r_i(tp, _mcu, index);				\
}

#define DEF_W_FUNC(_t, _w, _w_i, _mcu)				\
static inline void _w(struct r8152 *tp, u16 index, _t data)	\
{								\
	_w_i(tp, _mcu, index, data);				\
}

DEF_R_FUNC(u8, pla_ocp_read_byte, ocp_read_byte, MCU_TYPE_PLA)
DEF_W_FUNC(u8, pla_ocp_write_byte, ocp_write_byte, MCU_TYPE_PLA)
DEF_R_FUNC(u16, pla_ocp_read_word, ocp_read_word, MCU_TYPE_PLA)
DEF_W_FUNC(u16, pla_ocp_write_word, ocp_write_word, MCU_TYPE_PLA)
DEF_R_FUNC(u32, pla_ocp_read_dword, ocp_read_dword, MCU_TYPE_PLA)
DEF_W_FUNC(u32, pla_ocp_write_dword, ocp_write_dword, MCU_TYPE_PLA)

DEF_R_FUNC(u8, usb_ocp_read_byte, ocp_read_byte, MCU_TYPE_USB)
DEF_W_FUNC(u8, usb_ocp_write_byte, ocp_write_byte, MCU_TYPE_USB)
DEF_R_FUNC(u16, usb_ocp_read_word, ocp_read_word, MCU_TYPE_USB)
DEF_W_FUNC(u16, usb_ocp_write_word, ocp_write_word, MCU_TYPE_USB)
DEF_R_FUNC(u32, usb_ocp_read_dword, ocp_read_dword, MCU_TYPE_USB)
DEF_W_FUNC(u32, usb_ocp_write_dword, ocp_write_dword, MCU_TYPE_USB)
