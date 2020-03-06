Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B5B17BC21
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 12:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCFLtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 06:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgCFLts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 06:49:48 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E90582072A;
        Fri,  6 Mar 2020 11:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583495387;
        bh=QT7chaIcpIKaXbYWCdy+77ofMpMDRDGRvvTu75QlMnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n/6EQCf54zDryvHFtcOyjbYpRReGsUEpHCLrRBhgBozy0gXd5/YPk5svKHVwt4oee
         R2Hvml+CGY9GdfiNWysYtW0tgUNf0MvADD9PrhE1S/zXc+fcAM1OcLiBPvjKid3A65
         5ctG6XWqNyUK4vrwqf6fuguZ2POzWs+eSnY+PblU=
Date:   Fri, 6 Mar 2020 13:49:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/17] remoteproc: add IPA notification to q6v5 driver
Message-ID: <20200306114941.GO184088@unreal>
References: <20200306042831.17827-1-elder@linaro.org>
 <20200306042831.17827-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306042831.17827-2-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 10:28:15PM -0600, Alex Elder wrote:
> Set up a subdev in the q6v5 modem remoteproc driver that generates
> event notifications for the IPA driver to use for initialization and
> recovery following a modem shutdown or crash.
>
> A pair of new functions provides a way for the IPA driver to register
> and deregister a notification callback function that will be called
> whenever modem events (about to boot, running, about to shut down,
> etc.) occur.  A void pointer value (provided by the IPA driver at
> registration time) and an event type are supplied to the callback
> function.
>
> One event, MODEM_REMOVING, is signaled whenever the q6v5 driver is
> about to remove the notification subdevice.  It requires the IPA
> driver de-register its callback.
>
> This sub-device is only used by the modem subsystem (MSS) driver,
> so the code that adds the new subdev and allows registration and
> deregistration of the notifier is found in "qcom_q6v6_mss.c".
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/remoteproc/Kconfig                    |  6 ++
>  drivers/remoteproc/Makefile                   |  1 +
>  drivers/remoteproc/qcom_q6v5_ipa_notify.c     | 85 +++++++++++++++++++
>  drivers/remoteproc/qcom_q6v5_mss.c            | 38 +++++++++
>  .../linux/remoteproc/qcom_q6v5_ipa_notify.h   | 82 ++++++++++++++++++
>  5 files changed, 212 insertions(+)
>  create mode 100644 drivers/remoteproc/qcom_q6v5_ipa_notify.c
>  create mode 100644 include/linux/remoteproc/qcom_q6v5_ipa_notify.h
>
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index de3862c15fcc..56084635dd63 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -167,6 +167,12 @@ config QCOM_Q6V5_WCSS
>  	  Say y here to support the Qualcomm Peripheral Image Loader for the
>  	  Hexagon V5 based WCSS remote processors.
>
> +config QCOM_Q6V5_IPA_NOTIFY
> +	tristate
> +	depends on QCOM_IPA
> +	depends on QCOM_Q6V5_MSS
> +	default QCOM_IPA
> +
>  config QCOM_SYSMON
>  	tristate "Qualcomm sysmon driver"
>  	depends on RPMSG
> diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
> index e30a1b15fbac..0effd3825035 100644
> --- a/drivers/remoteproc/Makefile
> +++ b/drivers/remoteproc/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_QCOM_Q6V5_ADSP)		+= qcom_q6v5_adsp.o
>  obj-$(CONFIG_QCOM_Q6V5_MSS)		+= qcom_q6v5_mss.o
>  obj-$(CONFIG_QCOM_Q6V5_PAS)		+= qcom_q6v5_pas.o
>  obj-$(CONFIG_QCOM_Q6V5_WCSS)		+= qcom_q6v5_wcss.o
> +obj-$(CONFIG_QCOM_Q6V5_IPA_NOTIFY)	+= qcom_q6v5_ipa_notify.o
>  obj-$(CONFIG_QCOM_SYSMON)		+= qcom_sysmon.o
>  obj-$(CONFIG_QCOM_WCNSS_PIL)		+= qcom_wcnss_pil.o
>  qcom_wcnss_pil-y			+= qcom_wcnss.o
> diff --git a/drivers/remoteproc/qcom_q6v5_ipa_notify.c b/drivers/remoteproc/qcom_q6v5_ipa_notify.c
> new file mode 100644
> index 000000000000..e1c10a128bfd
> --- /dev/null
> +++ b/drivers/remoteproc/qcom_q6v5_ipa_notify.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Qualcomm IPA notification subdev support
> + *
> + * Copyright (C) 2019 Linaro Ltd.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/remoteproc.h>
> +#include <linux/remoteproc/qcom_q6v5_ipa_notify.h>
> +
> +static void
> +ipa_notify_common(struct rproc_subdev *subdev, enum qcom_rproc_event event)
> +{
> +	struct qcom_rproc_ipa_notify *ipa_notify;
> +	qcom_ipa_notify_t notify;
> +
> +	ipa_notify = container_of(subdev, struct qcom_rproc_ipa_notify, subdev);
> +	notify = ipa_notify->notify;
> +	if (notify)
> +		notify(ipa_notify->data, event);
> +}
> +
> +static int ipa_notify_prepare(struct rproc_subdev *subdev)
> +{
> +	ipa_notify_common(subdev, MODEM_STARTING);
> +
> +	return 0;
> +}
> +
> +static int ipa_notify_start(struct rproc_subdev *subdev)
> +{
> +	ipa_notify_common(subdev, MODEM_RUNNING);
> +
> +	return 0;
> +}
> +
> +static void ipa_notify_stop(struct rproc_subdev *subdev, bool crashed)
> +
> +{
> +	ipa_notify_common(subdev, crashed ? MODEM_CRASHED : MODEM_STOPPING);
> +}
> +
> +static void ipa_notify_unprepare(struct rproc_subdev *subdev)
> +{
> +	ipa_notify_common(subdev, MODEM_OFFLINE);
> +}
> +
> +static void ipa_notify_removing(struct rproc_subdev *subdev)
> +{
> +	ipa_notify_common(subdev, MODEM_REMOVING);
> +}
> +
> +/* Register the IPA notification subdevice with the Q6V5 MSS remoteproc */
> +void qcom_add_ipa_notify_subdev(struct rproc *rproc,
> +		struct qcom_rproc_ipa_notify *ipa_notify)
> +{
> +	ipa_notify->notify = NULL;
> +	ipa_notify->data = NULL;
> +	ipa_notify->subdev.prepare = ipa_notify_prepare;
> +	ipa_notify->subdev.start = ipa_notify_start;
> +	ipa_notify->subdev.stop = ipa_notify_stop;
> +	ipa_notify->subdev.unprepare = ipa_notify_unprepare;
> +
> +	rproc_add_subdev(rproc, &ipa_notify->subdev);
> +}
> +EXPORT_SYMBOL_GPL(qcom_add_ipa_notify_subdev);
> +
> +/* Remove the IPA notification subdevice */
> +void qcom_remove_ipa_notify_subdev(struct rproc *rproc,
> +		struct qcom_rproc_ipa_notify *ipa_notify)
> +{
> +	struct rproc_subdev *subdev = &ipa_notify->subdev;
> +
> +	ipa_notify_removing(subdev);
> +
> +	rproc_remove_subdev(rproc, subdev);
> +	ipa_notify->notify = NULL;	/* Make it obvious */
> +}
> +EXPORT_SYMBOL_GPL(qcom_remove_ipa_notify_subdev);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Qualcomm IPA notification remoteproc subdev");
> diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
> index a1cc9cbe038f..f9ccce76e44b 100644
> --- a/drivers/remoteproc/qcom_q6v5_mss.c
> +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> @@ -22,6 +22,7 @@
>  #include <linux/regmap.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/remoteproc.h>
> +#include "linux/remoteproc/qcom_q6v5_ipa_notify.h"
>  #include <linux/reset.h>
>  #include <linux/soc/qcom/mdt_loader.h>
>  #include <linux/iopoll.h>
> @@ -201,6 +202,7 @@ struct q6v5 {
>  	struct qcom_rproc_glink glink_subdev;
>  	struct qcom_rproc_subdev smd_subdev;
>  	struct qcom_rproc_ssr ssr_subdev;
> +	struct qcom_rproc_ipa_notify ipa_notify_subdev;
>  	struct qcom_sysmon *sysmon;
>  	bool need_mem_protection;
>  	bool has_alt_reset;
> @@ -1540,6 +1542,39 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
>  	return 0;
>  }
>
> +#if IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY)
> +
> +/* Register IPA notification function */
> +int qcom_register_ipa_notify(struct rproc *rproc, qcom_ipa_notify_t notify,
> +			     void *data)
> +{
> +	struct qcom_rproc_ipa_notify *ipa_notify;
> +	struct q6v5 *qproc = rproc->priv;
> +
> +	if (!notify)
> +		return -EINVAL;
> +
> +	ipa_notify = &qproc->ipa_notify_subdev;
> +	if (ipa_notify->notify)
> +		return -EBUSY;
> +
> +	ipa_notify->notify = notify;
> +	ipa_notify->data = data;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(qcom_register_ipa_notify);
> +
> +/* Deregister IPA notification function */
> +void qcom_deregister_ipa_notify(struct rproc *rproc)
> +{
> +	struct q6v5 *qproc = rproc->priv;
> +
> +	qproc->ipa_notify_subdev.notify = NULL;
> +}
> +EXPORT_SYMBOL_GPL(qcom_deregister_ipa_notify);
> +#endif /* !IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY) */
> +
>  static int q6v5_probe(struct platform_device *pdev)
>  {
>  	const struct rproc_hexagon_res *desc;
> @@ -1664,6 +1699,7 @@ static int q6v5_probe(struct platform_device *pdev)
>  	qcom_add_glink_subdev(rproc, &qproc->glink_subdev);
>  	qcom_add_smd_subdev(rproc, &qproc->smd_subdev);
>  	qcom_add_ssr_subdev(rproc, &qproc->ssr_subdev, "mpss");
> +	qcom_add_ipa_notify_subdev(rproc, &qproc->ipa_notify_subdev);
>  	qproc->sysmon = qcom_add_sysmon_subdev(rproc, "modem", 0x12);
>  	if (IS_ERR(qproc->sysmon)) {
>  		ret = PTR_ERR(qproc->sysmon);
> @@ -1677,6 +1713,7 @@ static int q6v5_probe(struct platform_device *pdev)
>  	return 0;
>
>  detach_proxy_pds:
> +	qcom_remove_ipa_notify_subdev(qproc->rproc, &qproc->ipa_notify_subdev);
>  	q6v5_pds_detach(qproc, qproc->proxy_pds, qproc->proxy_pd_count);
>  detach_active_pds:
>  	q6v5_pds_detach(qproc, qproc->active_pds, qproc->active_pd_count);
> @@ -1693,6 +1730,7 @@ static int q6v5_remove(struct platform_device *pdev)
>  	rproc_del(qproc->rproc);
>
>  	qcom_remove_sysmon_subdev(qproc->sysmon);
> +	qcom_remove_ipa_notify_subdev(qproc->rproc, &qproc->ipa_notify_subdev);
>  	qcom_remove_glink_subdev(qproc->rproc, &qproc->glink_subdev);
>  	qcom_remove_smd_subdev(qproc->rproc, &qproc->smd_subdev);
>  	qcom_remove_ssr_subdev(qproc->rproc, &qproc->ssr_subdev);
> diff --git a/include/linux/remoteproc/qcom_q6v5_ipa_notify.h b/include/linux/remoteproc/qcom_q6v5_ipa_notify.h
> new file mode 100644
> index 000000000000..0820edc0ab7d
> --- /dev/null
> +++ b/include/linux/remoteproc/qcom_q6v5_ipa_notify.h
> @@ -0,0 +1,82 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/* Copyright (C) 2019 Linaro Ltd. */
> +
> +#ifndef __QCOM_Q6V5_IPA_NOTIFY_H__
> +#define __QCOM_Q6V5_IPA_NOTIFY_H__
> +
> +#if IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY)

Why don't you put this guard in the places where such include is called?
Or the best variant is to ensure that this include is compiled in only
in CONFIG_QCOM_Q6V5_IPA_NOTIFY flows.

That is more common way to guard internal header files.

Thanks
