Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6598814EF87
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgAaP06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbgAaP06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:26:58 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B53AC206D5;
        Fri, 31 Jan 2020 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580484418;
        bh=8bPwW4LrmJ+PVnjMs+ARhvw7tW2cm8yjannViNU4bpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y2q0ol+O1mcO3+6i5O/OkxxSMvb11c5j5hICzT45aCQBt99RPQjvh00IObCfOjPBE
         8iqIKArVqCx0mk9wZu9im9nUiDfcYBg5tbFoP5pe36C9TAIMkDdNatCpsBtHr/0YV7
         XxMXk0U3SPMvuSmcJeevMdQHfYIlVJavdCc5a5AM=
Date:   Fri, 31 Jan 2020 07:26:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, vladimir.oltean@nxp.com,
        po.liu@nxp.com
Subject: Re: [PATCH net v3 2/2] taprio: Fix still allowing changing the
 flags during runtime
Message-ID: <20200131072656.0b899074@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130013721.33812-3-vinicius.gomes@intel.com>
References: <20200130013721.33812-1-vinicius.gomes@intel.com>
        <20200130013721.33812-3-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 17:37:21 -0800, Vinicius Costa Gomes wrote:
> +static int taprio_new_flags(const struct nlattr *attr, u32 old,
> +			    struct netlink_ext_ack *extack)
> +{
> +	u32 new =3D 0;

TCA_TAPRIO_ATTR_FLAGS doesn't seem to be in the netlink policy =F0=9F=98=96

> +	if (attr)
> +		new =3D nla_get_u32(attr);
> +
> +	if (old !=3D TAPRIO_FLAGS_INVALID && old !=3D new) {
> +		NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is =
not supported");
> +		return -ENOTSUPP;

-EOPNOTSUPP

> +	}
> +
> +	if (!taprio_flags_valid(new)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
> +		return -EINVAL;
> +	}
> +
> +	return new;
> +}
