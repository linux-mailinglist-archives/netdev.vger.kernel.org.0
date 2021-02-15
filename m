Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9190531C2A3
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhBOTtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhBOTtE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 14:49:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80C1564DE0;
        Mon, 15 Feb 2021 19:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613418503;
        bh=7P7ywkXtXv5qTbHgZ/5qoDL3gQu62y8OrUQD7YwV8Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EN1+uUrMuThAGCa+TRFQ8nQ7el4cznY5YoCViDZ5J6o3hOOkDWERJo8I4/Nv9pND1
         ONqpVMw+gtaeX4iKCmRoLrK+Wxn7w3QWWSpeHUtD7xKmIO52FcKAmWYQuxWZAofbX/
         1vCWwoNt1Lyv6qt6LZCqf7ybxOwYhkhdkbN6AnO2vPEoUh4W8+HnvIxTta36C4bEjA
         8GfeVmhwfnEsqtOfKL58jAlEBKRPcz89UnNk7iXsNxyDiGvfCoECXPf5X5VISPwKHT
         WsBi8ogACdqVsSWwqxL+Bi2sP+4egeCbk8c1rUW/I4GR7KXPfgDNIXl6+D4nhc+9ym
         xaP5QUJoni7Ew==
Date:   Mon, 15 Feb 2021 11:48:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <vincent.cheng.xh@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 1/3] ptp: ptp_clockmatrix: Add
 wait_for_sys_apll_dpll_lock.
Message-ID: <20210215114822.4f698920@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1613192766-14010-2-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
        <1613192766-14010-2-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Feb 2021 00:06:04 -0500 vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Part of the device initialization aligns the rising edge of the output
> clock to the internal 1 PPS clock. If the system APLL and DPLL is not
> locked, then the alignment will fail and there will be a fixed offset
> between the internal 1 PPS clock and the output clock.
> 
> After loading the device firmware, poll the system APLL and DPLL for
> locked state prior to initialization, timing out after 2 seconds.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

> diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
> index a664dfe..ac524cf 100644
> --- a/drivers/ptp/idt8a340_reg.h
> +++ b/drivers/ptp/idt8a340_reg.h
> @@ -122,6 +122,8 @@
>  #define OTP_SCSR_CONFIG_SELECT            0x0022
>  
>  #define STATUS                            0xc03c
> +#define DPLL_SYS_STATUS                   0x0020
> +#define DPLL_SYS_APLL_STATUS              0x0021
>  #define USER_GPIO0_TO_7_STATUS            0x008a
>  #define USER_GPIO8_TO_15_STATUS           0x008b
>  
> @@ -707,4 +709,12 @@
>  /* Bit definitions for the DPLL_CTRL_COMBO_MASTER_CFG register */
>  #define COMBO_MASTER_HOLD                 BIT(0)
>  
> +/* Bit definitions for DPLL_SYS_STATUS register */
> +#define DPLL_SYS_STATE_MASK               (0xf)
> +
> +/* Bit definitions for SYS_APLL_STATUS register */
> +#define SYS_APLL_LOSS_LOCK_LIVE_MASK       BIT(0)
> +#define SYS_APLL_LOSS_LOCK_LIVE_LOCKED     0
> +#define SYS_APLL_LOSS_LOCK_LIVE_UNLOCKED   1
> +
>  #endif
> diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
> index 051511f..3de8411 100644
> --- a/drivers/ptp/ptp_clockmatrix.c
> +++ b/drivers/ptp/ptp_clockmatrix.c
> @@ -335,6 +335,79 @@ static int wait_for_boot_status_ready(struct idtcm *idtcm)
>  	return -EBUSY;
>  }
>  
> +static int read_sys_apll_status(struct idtcm *idtcm, u8 *status)
> +{
> +	int err;
> +
> +	err = idtcm_read(idtcm, STATUS, DPLL_SYS_APLL_STATUS, status,
> +			 sizeof(u8));
> +	return err;

Please remove the unnecessary 'err' variable:

	return idtcm_read(..

There are bots scanning the tree for such code simplifications, 
better to get this right from the start than deal with flood of 
simplifications patches.

> +}
> +
> +static int read_sys_dpll_status(struct idtcm *idtcm, u8 *status)
> +{
> +	int err;
> +
> +	err = idtcm_read(idtcm, STATUS, DPLL_SYS_STATUS, status, sizeof(u8));
> +
> +	return err;

same here

> +}
> +
> +static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
> +{
> +	const char *fmt = "%d ms SYS lock timeout: APLL Loss Lock %d  DPLL state %d";
> +	u8 i = LOCK_TIMEOUT_MS / LOCK_POLL_INTERVAL_MS;

Using msleep() and loops is quite inaccurate. I'd recommend you switch
to:

	unsigned long timeout = jiffies + msecs_to_jiffies(LOCK_TIMEOUT_MS);

And then use:

	while (time_is_after_jiffies(timeout))

For the condition.

> +	u8 apll = 0;
> +	u8 dpll = 0;
> +
> +	int err;

No empty lines between variables, please.

> +
> +	do {
> +		err = read_sys_apll_status(idtcm, &apll);
> +

No empty lines between call and the if, please.

> +		if (err)
> +			return err;
> +
> +		err = read_sys_dpll_status(idtcm, &dpll);
> +
> +		if (err)
> +			return err;
> +
> +		apll &= SYS_APLL_LOSS_LOCK_LIVE_MASK;
> +		dpll &= DPLL_SYS_STATE_MASK;
> +
> +		if ((apll == SYS_APLL_LOSS_LOCK_LIVE_LOCKED)

parenthesis around a == b are unnecessary.

> +		    && (dpll == DPLL_STATE_LOCKED)) {
> +			return 0;
> +		} else if ((dpll == DPLL_STATE_FREERUN) ||
> +			   (dpll == DPLL_STATE_HOLDOVER) ||
> +			   (dpll == DPLL_STATE_OPEN_LOOP)) {

same here.

> +			dev_warn(&idtcm->client->dev,
> +				"No wait state: DPLL_SYS_STATE %d", dpll);

It looks like other prints in this function use \n at the end of the
lines, should we keep it consistent?

> +			return -EPERM;
> +		}
> +
> +		msleep(LOCK_POLL_INTERVAL_MS);
> +		i--;
> +

unnecessary empty line

> +	} while (i);
> +
> +	dev_warn(&idtcm->client->dev, fmt, LOCK_TIMEOUT_MS, apll, dpll);

I'd recommend leaving the format in place, that way static code
checkers can validate the arguments.

> +	return -ETIME;

> +}
> +
> +static void wait_for_chip_ready(struct idtcm *idtcm)
> +{
> +	if (wait_for_boot_status_ready(idtcm))
> +		dev_warn(&idtcm->client->dev, "BOOT_STATUS != 0xA0");

no new line?

> +
> +	if (wait_for_sys_apll_dpll_lock(idtcm))
> +		dev_warn(&idtcm->client->dev,
> +			 "Continuing while SYS APLL/DPLL is not locked");

And here.

> +}
> +
>  static int _idtcm_gettime(struct idtcm_channel *channel,
>  			  struct timespec64 *ts)
>  {
> @@ -2235,8 +2308,7 @@ static int idtcm_probe(struct i2c_client *client,
>  		dev_warn(&idtcm->client->dev,
>  			 "loading firmware failed with %d\n", err);
>  
> -	if (wait_for_boot_status_ready(idtcm))
> -		dev_warn(&idtcm->client->dev, "BOOT_STATUS != 0xA0\n");
> +	wait_for_chip_ready(idtcm);
>  
>  	if (idtcm->tod_mask) {
>  		for (i = 0; i < MAX_TOD; i++) {
> diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
> index 645de2c..0233236 100644
> --- a/drivers/ptp/ptp_clockmatrix.h
> +++ b/drivers/ptp/ptp_clockmatrix.h
> @@ -51,6 +51,9 @@
>  #define TOD_WRITE_OVERHEAD_COUNT_MAX		(2)
>  #define TOD_BYTE_COUNT				(11)
>  
> +#define LOCK_TIMEOUT_MS			(2000)
> +#define LOCK_POLL_INTERVAL_MS		(10)
> +
>  #define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
>  
>  #define IDTCM_MAX_WRITE_COUNT		(512)
> @@ -105,6 +108,18 @@ enum scsr_tod_write_type_sel {
>  	SCSR_TOD_WR_TYPE_SEL_MAX = SCSR_TOD_WR_TYPE_SEL_DELTA_MINUS,
>  };
>  
> +/* Values STATUS.DPLL_SYS_STATUS.DPLL_SYS_STATE */
> +enum dpll_state {
> +	DPLL_STATE_MIN = 0,
> +	DPLL_STATE_FREERUN = DPLL_STATE_MIN,
> +	DPLL_STATE_LOCKACQ = 1,
> +	DPLL_STATE_LOCKREC = 2,
> +	DPLL_STATE_LOCKED = 3,
> +	DPLL_STATE_HOLDOVER = 4,
> +	DPLL_STATE_OPEN_LOOP = 5,
> +	DPLL_STATE_MAX = DPLL_STATE_OPEN_LOOP,
> +};
> +
>  struct idtcm;
>  
>  struct idtcm_channel {

